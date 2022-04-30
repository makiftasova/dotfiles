#! /usr/bin/env bash

# this script expect you to have a privilidged user account (e.g. with sudo access)

if [[ "$(grep -e '^ID=' /etc/os-release | cut -d'=' -f2 || true)" != 'arch' ]]; then
	echo 'Distros other than Arch Linux is not supported'
	exit 253
fi

if [[ "${EUID}" -eq '0' ]]; then
	echo 'Running makepkg as root is not allowed.'
	echo 'This script will call "sudo" whenever it needs to do privilidged actions'
	exit 254
fi

check_command () {
	# $1 command (e.g. "sudo")
	# $2 path (e.g. "/usr/bin/sudo")
	if [[ -z "${2}" ]]; then
		echo "Command '$1' not found" >&2
		exit 255
	fi
}

AUTH="$(command -v 'sudo')"
PACMAN="$(command -v 'pacman')"

check_command 'sudo' "${AUTH}"
check_command 'pacman' "${PACMAN}"

check_depends () {
	if ! "${AUTH}" "${PACMAN}" '-S' '--needed' 'base-devel' 'git' 'vifm'; then
		echo 'Could not install base-devel package via pacman'
		exit 100
	fi
}
check_depends

AURUTILS_URL='https://aur.archlinux.org/aurutils.git'

AUR_REPO_DIR='/var/cache/pacman/aur'
AUR_REPO_DB_DIR="${AUR_REPO_DIR}/aur.db.tar"
AUR_PKG_NAME='aurutils'
PACMAN_CONF='/etc/pacman.conf'

CAT="$(command -v 'cat')"
GIT="$(command -v 'git')"
INSTALL="$(command -v 'install')"
MAKEPKG="$(command -v 'makepkg')"
MKTEMP="$(command -v 'mktemp')"
REPO_ADD="$(command -v 'repo-add')"
RM="$(command -v 'rm')"
TEE="$(command -v 'tee')"
WHOAMI="$(command -v 'whoami')"

check_command 'cat' "${CAT}"
check_command 'git' "${GIT}"
check_command 'install' "${INSTALL}"
check_command 'makepkg' "${MAKEPKG}"
check_command 'mktemp' "${MKTEMP}"
check_command 'repo-add' "${REPO_ADD}"
check_command 'rm' "${RM}"
check_command 'tee' "${TEE}"
check_command 'whoami' "${WHOAMI}"

OWNER="$("${WHOAMI}")"

append_aurconf () {
"${AUTH}" "${TEE}" '-a' "${PACMAN_CONF}" << PACMANAURCONF

# Local repository for aur packages
[aur]
SigLevel = Optional TrustAll
Server = file://${AUR_REPO_DIR}
PACMANAURCONF
return 0
}

echo "Using ${AUR_REPO_DIR} as local repository directory"
echo "Using ${AUR_REPO_DB_DIR} as local repository database"

check_aur_repo () {
	local repo_config
	local aur_cmd

	repo_config="$(grep -e '^\[aur\]$' "${PACMAN_CONF}")"
	aur_cmd="$(command -v 'aur')"

	if [[ -d "${AUR_REPO_DIR}" && -f "${AUR_REPO_DB_DIR}" &&
	      -n "${aur_cmd}" && -n "${repo_config}" ]]; then
		echo "It looks like local aur repo already configured"
		exit 252
	fi
}
check_aur_repo

echo "Using ${AUTH} for authentication"

if ! [[ -r "${PACMAN_CONF}" ]]; then
	echo "${PACMAN_CONF} does not esists or not readable by user ${OWNER}"
	exit 251
fi

TEMP_DIR="$("${MKTEMP}" '-d' '/tmp/aurutils.XXXXXX')"
if ! [[ -d "${TEMP_DIR}" ]]; then
	echo "could not create temporary directory"
	exit 250
fi

cleanup () {
	"${RM}" -rf "${TEMP_DIR}"
}
trap cleanup EXIT

if ! "${GIT}" clone "${AURUTILS_URL}" "${TEMP_DIR}"; then
	echo "Could not clone aurutils repo from ${AURUTILS_URL}"
	exit 249
fi

ORIGINAL_DIR="$(pwd)"
if ! cd "${TEMP_DIR}"; then
	echo "Could not cd into ${TEMP_DIR}"
	exit 248
fi
if ! "${MAKEPKG}" '-si'; then
	echo "makpkg failed";
	exit 247
fi
if ! cd "${ORIGINAL_DIR}"; then
	echo "Could not cd back into ${ORIGINAL_DIR}"
	exit 246
fi

#from now on, 'aur' command should be available
AUR="$(command -v 'aur')"
check_command 'aur' "${AUR}"

if ! "${AUTH}" "${INSTALL}" -d "${AUR_REPO_DIR}" -o "${OWNER}"; then
	echo "Could not create aur repo directory"
	exit 245
fi

if ! "${REPO_ADD}" '-n' "${AUR_REPO_DB_DIR}"; then
	echo "Could not setup local aur repo at ${AUR_REPO_DB_DIR}"
	exit 244
fi

if ! append_aurconf; then
	echo "Could not append local repo to ${PACMAN_CONF}"
	exit 243
fi

if ! "${AUR}" 'sync' "${AUR_PKG_NAME}"; then
	echo "Could not install ${AUR_PKG_NAME}"
	exit 242
fi

if ! "${AUTH}" "${PACMAN}" '-S' "${AUR_PKG_NAME}"; then
	echo "Could not install ${AUR_PKG_NAME} from local aur repository"
	exit 241
fi

echo "Done setting up ${AUR_PKG_NAME}"
exit 0
