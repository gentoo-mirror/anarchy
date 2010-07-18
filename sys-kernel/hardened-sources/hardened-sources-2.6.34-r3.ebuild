# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="4"

inherit kernel-2
detect_version

GRSEC_VERSION="2.2.0-2.6.34.1-201007162107"
GRSEC_PATCH="grsecurity-${GRSEC_VERSION}.patch"
GRSEC_URI="http://dev.gentoo.org/~anarchy/grsecurity/${GRSEC_PATCH}"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${GRSEC_URI}"

UNIPATCH_STRICTORDER="y"
UNIPATCH_LIST="${DISTDIR}/${GRSEC_PATCH}"
UNIPATCH_EXCLUDE="*_fbcondecor-0.9.6.patch"

DESCRIPTION="Hardened kernel sources (kernel series ${KV_MAJOR}.${KV_MINOR})"
HOMEPAGE="http://www.grsecurity.com"
IUSE=""

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

pkg_postinst() {
	kernel-2_pkg_postinst

	local GRADM_COMPAT="sys-apps/gradm-2.2.0*"

	ewarn
	ewarn "Users of grsecurity's RBAC system must ensure they are using"
	ewarn "${GRADM_COMPAT}, which is compatible with kernel series ${OKV}."
	ewarn "Therefore, it is strongly recommended that the following command is"
	ewarn "issued prior to booting a ${P} series kernel for"
	ewarn "the first time:"
	ewarn
	ewarn "emerge -na =${GRADM_COMPAT}"
	ewarn
}
