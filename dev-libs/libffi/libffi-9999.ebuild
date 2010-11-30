# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils libtool

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/atgreen/libffi.git"
	inherit git
	KEYWORDS=""
else
	SRC_URI="ftp://sourceware.org/pub/${PN}/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux 
	~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="a portable, high level programming interface to various calling conventions."
HOMEPAGE="http://sourceware.org/libffi/"
LICENSE="MIT"
SLOT="0"

IUSE="debug static-libs test"

RDEPEND=""
DEPEND="test? ( dev-util/dejagnu )"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
	else
		unpack ${A}
		cd "${S}"

		epatch "${FILESDIR}"/${P}-interix.patch \
			"${FILESDIR}"/${P}-irix.patch \
			"${FILESDIR}"/${P}-arm-oabi.patch

		elibtoolize
	fi
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable debug)
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog* README
	find "${D}" -type f -name '*.la' -exec rm -f '{}' +
}
