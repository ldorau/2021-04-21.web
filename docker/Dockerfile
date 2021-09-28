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
	json-c-devel\
	keyutils-libs-devel\
	kmod-devel\
	lbzip2\
	libatomic\
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

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -

RUN dnf install -y nodejs

RUN dnf debuginfo-install -y glibc

RUN dnf clean all

COPY pmdk.sh /
RUN /pmdk.sh

COPY valgrind.sh /
RUN /valgrind.sh

COPY pmemobj-cpp.sh /
RUN /pmemobj-cpp.sh

COPY pmemkv.sh /
RUN /pmemkv.sh

COPY pmemkv-jni.sh /
RUN /pmemkv-jni.sh

COPY pmemkv-java.sh /
RUN /pmemkv-java.sh

COPY pmemkv-python.sh /
RUN /pmemkv-python.sh

COPY pmemkv-nodejs.sh /
RUN /pmemkv-nodejs.sh

COPY pmemkv-ruby.sh /
RUN /pmemkv-ruby.sh

COPY memkind.sh /
RUN /memkind.sh

COPY tz.sh /
RUN /tz.sh

COPY librpma.sh /
RUN /librpma.sh

RUN rm /pmdk.sh /valgrind.sh /pmemobj-cpp.sh /pmemkv.sh /pmemkv-jni.sh /pmemkv-java.sh /pmemkv-python.sh /pmemkv-nodejs.sh /pmemkv-ruby.sh /memkind.sh /tz.sh /librpma.sh
