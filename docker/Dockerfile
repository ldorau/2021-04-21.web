#
# dockerfile for pmemhackathon, fc30 based
#

FROM fedora:30

LABEL maintainer="andy.rudoff@intel.com"

RUN dnf update -y && dnf install -y\
	asciidoc\
	asciidoctor\
	autoconf\
	automake\
	bash-completion\
	bc\
	bind-utils\
	binutils\
	clang\
	cmake\
	daxctl-devel\
	doxygen\
	emacs\
	file\
	findutils\
	fuse\
	fuse-devel\
	gcc\
	gcc-c++\
	gdb\
	git-all\
	glib2-devel\
	golang\
	gtest-devel\
	hub\
	iproute\
	iputils\
	json-c-devel\
	keyutils-libs-devel\
	kmod-devel\
	lbzip2\
	libatomic\
	librdmacm-utils\
	libtool\
	libudev-devel\
	libunwind-devel\
	libuuid-devel\
	libuv-devel\
	make\
	man\
	memkind\
	memkind-devel\
	nano\
	net-tools\
	ncurses-devel\
	ndctl-devel\
	numactl-devel\
	java-1.8.0-openjdk\
	openssh-server\
	pandoc\
	passwd\
	perl-Text-Diff\
	pkgconfig\
	python3-devel\
	rapidjson-devel\
	rdma-core-devel\
	rpm-build\
	rpm-build-libs\
	rpmdevtools\
	rsync\
	ruby-devel\
	strace\
	tar\
	tbb-devel\
	unzip\
	vim-enhanced\
	wget\
	which\
	xmlto\
	xmvn

COPY pmdk.sh /
RUN /pmdk.sh

COPY librpma.sh /
RUN /librpma.sh
