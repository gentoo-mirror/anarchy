# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="skarnet.org implementation of the utmpx.h family of functions"
HOMEPAGE="https://www.skarnet.org/software/${PN}/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static static-libs"

REQUIRED_USE="static? ( static-libs )"

DEPEND=">=dev-libs/skalibs-2.8.0.0[static-libs?]"

RDEPEND="!static? ( >=dev-libs/skalibs-2.8.0.0:= )"

DOCS="AUTHORS README*"
HTML_DOCS="doc/*"

pkg_setup() {
	# Make sure utmp group exists, as it's used later on.
	enewgroup utmp 406
	enewuser utmp -1 -1 /dev/null utmp
}

src_prepare() {
	default

	# Remove QA warning about LDFLAGS addition
	sed -i "s/tryldflag LDFLAGS_AUTO -Wl,--hash-style=both/:/" "${S}/configure" || die

	# configure overrides gentoo's -fstack-protector default
	sed -i "/^tryflag CFLAGS -fno-stack-protector$/d" "${S}/configure" || die
}

src_configure() {
	econf \
		--bindir=/bin \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--with-dynlib=/$(get_libdir) \
		--with-lib=/usr/$(get_libdir)/execline \
		--with-lib=/usr/$(get_libdir)/skalibs \
		--with-sysdeps=/usr/$(get_libdir)/skalibs \
		--enable-shared \
		$(use_enable static allstatic) \
		$(use_enable static static-libc) \
		$(use_enable static-libs static)
}

src_install() {
	default

	newinitd "${FILESDIR}/init.d.utmpd" utmpd
	newinitd "${FILESDIR}/init.d.wtmpd" wtmpd
}