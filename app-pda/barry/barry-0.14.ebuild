# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base

DESCRIPTION="Barry is an Open Source Linux application that will allow
synchronization, backup, restore, program management, and charging for BlackBerry devices"
HOMEPAGE="http://www.netdirect.ca/software/packages/barry/"
SRC_URI="mirror://sourceforge/barry/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND="dev-libs/libusb
	dev-libs/openssl
	gtk? ( dev-cpp/libglademm 
			dev-libs/libtar )"

PATCHES=( "${FILESDIR}/${P}-gcc44.patch" 
	"${FILESDIR}/${P}-glibc-2.10.1.patch" )

src_compile(){
	econf \
		$(use_enable gtk gui)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS

	#  udev rules
	insinto /etc/udev/rules.d
	newins udev/10-blackberry.rules 10-blackberry.rules
}
