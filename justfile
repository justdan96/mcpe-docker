default:
  just --list

build-client:
  git clone --branch qt6 --recursive https://github.com/minecraft-linux/mcpelauncher-manifest.git mcpelauncher 
  cd ./mcpelauncher/mcpelauncher-core && git checkout master
  cd ./mcpelauncher/mcpelauncher-client && git checkout master
  cd ./mcpelauncher/libc-shim && git checkout master
  mkdir -p ./mcpelauncher/build
  cd ./mcpelauncher/build && \
  CC=clang CXX=clang++ cmake .. -Wno-dev -DCMAKE_BUILD_TYPE=Release -DJNI_USE_JNIVM=ON -DJNIVM_ENABLE_DEBUG=ON -DJNIVM_ENABLE_TRACE=ON \
  -DBUILD_FAKE_JNI_EXAMPLES=OFF -DQT_VERSION=6  -DCMAKE_INSTALL_PREFIX=/opt/mcpe
  cd ./mcpelauncher/build && make -j $(nproc --ignore=2)

install-client:
  cd ./mcpelauncher/build && make install

deb-client:
  cd ./mcpelauncher/build && get-deps ./mcpelauncher-client/mcpelauncher-client >> deps.txt
  cd ./mcpelauncher/build && get-deps ./mcpelauncher-errorwindow/mcpelauncher-error >> deps.txt
  cd ./mcpelauncher/build && get-deps ./mcpelauncher-webview/mcpelauncher-webview >> deps.txt
  cd ./mcpelauncher/build && sed -i -e '/libhogweed5/d' -e '/libnettle7/d' -e '/libldap-2.4-2/d' -e '/libsystemd0/d' deps.txt
  cd ./mcpelauncher/build && echo mcpelauncher > description-pak
  cd ./mcpelauncher/build && checkinstall -y --pkgname mcpelauncher --maintainer ChristopherHX --pkglicense WTFPL --pkgarch amd64 \
    --pkgsource https://github.com/minecraft-linux/mcpelauncher-manifest --pkggroup mcpelauncher --nodoc --pkgversion 0.5.0-$(cd .. && git rev-parse --short HEAD) \
    --requires $(sort < deps.txt | uniq | paste -s -d,) --provides mcpelauncher-client,mcpelauncher-error,mcpelauncher-webview --install=no --fstrans=yes
  cd ./mcpelauncher/build && cp mcpelauncher*.deb ../../mcpelauncher.deb

build-client-justdan96:
  git clone --branch qt6 --recursive https://github.com/minecraft-linux/mcpelauncher-manifest.git mcpelauncher 
  cd ./mcpelauncher/mcpelauncher-core && git checkout 178bd978865a71c1ce1fad986a0893e75e3c347b
  cd ./mcpelauncher/ && rm -rf mcpelauncher-client && git clone --branch master https://github.com/justdan96/mcpelauncher-client.git
  mkdir -p ./mcpelauncher/build
  cd ./mcpelauncher/build && \
  CC=clang CXX=clang++ cmake .. -Wno-dev -DCMAKE_BUILD_TYPE=Release -DJNI_USE_JNIVM=ON \
  -DBUILD_FAKE_JNI_EXAMPLES=OFF -DQT_VERSION=6  -DCMAKE_INSTALL_PREFIX=/opt/mcpe
  cd ./mcpelauncher/build && make -j $(nproc --ignore=2)

build-ui:
  git clone --branch qt6 --recursive https://github.com/minecraft-linux/mcpelauncher-ui-manifest.git mcpelauncher-ui
  mkdir -p ./mcpelauncher-ui/build
  cd ./mcpelauncher-ui/mcpelauncher-ui-qt && git checkout qt6
  cd ./mcpelauncher-ui/playdl-signin-ui-qt && git checkout qt6
  cd ./mcpelauncher-ui/build && cmake -DCMAKE_INSTALL_PREFIX=/opt/mcpe -DLAUNCHER_CHANGE_LOG="<p>Testing</p>" \
  -DLAUNCHER_VERSIONDB_URL=https://raw.githubusercontent.com/minecraft-linux/mcpelauncher-versiondb/master \
   -DCMAKE_BUILD_TYPE=Release ..
  cd ./mcpelauncher-ui/build && make -j $(nproc --ignore=2)

install-ui:
  cd ./mcpelauncher-ui/build && make install

deb-ui:
  cd ./mcpelauncher-ui/build && get-deps ./mcpelauncher-ui-qt/mcpelauncher-ui-qt >> deps.txt
  cd ./mcpelauncher-ui/build && sed -i -e '/libhogweed5/d' -e '/libnettle7/d' -e '/libldap-2.4-2/d' -e '/libsystemd0/d' deps.txt
  cd ./mcpelauncher-ui/build && echo libqt6core6 >> deps.txt
  cd ./mcpelauncher-ui/build && echo libqt6quick6 >> deps.txt
  cd ./mcpelauncher-ui/build && echo libqt6qml6 >> deps.txt
  cd ./mcpelauncher-ui/build && echo libqt6qmlworkerscript6 >> deps.txt
  cd ./mcpelauncher-ui/build && echo qml6-module-qtqml-workerscript >> deps.txt
  cd ./mcpelauncher-ui/build && echo qml6-module-qtquick-window >> deps.txt
  cd ./mcpelauncher-ui/build && echo qml6-module-qtquick-dialogs >> deps.txt
  cd ./mcpelauncher-ui/build && echo qml6-module-qtquick-controls >> deps.txt
  cd ./mcpelauncher-ui/build && echo qml6-module-qtquick-templates >> deps.txt
  cd ./mcpelauncher-ui/build && echo qml6-module-qtquick-layouts >> deps.txt
  cd ./mcpelauncher-ui/build && echo qml6-module-qt-labs-platform >> deps.txt
  cd ./mcpelauncher-ui/build && echo mcpelauncher-ui > description-pak
  cd ./mcpelauncher-ui/build && checkinstall -y --pkgname mcpelauncher-ui --maintainer ChristopherHX --pkglicense WTFPL --pkgarch amd64 \
  --pkgsource https://github.com/minecraft-linux/mcpelauncher-ui-manifest --pkggroup mcpelauncher --nodoc --pkgversion 0.5.0-$(cd .. && git rev-parse --short HEAD) \
  --requires $(sort < deps.txt | uniq | paste -s -d,) --provides mcpelauncher-ui-qt --install=no --fstrans=yes
  cd ./mcpelauncher-ui/build && cp mcpelauncher-ui*.deb ../../mcpelauncher-ui.deb

build-ui-justdan96:
  git clone --branch qt6 --recursive https://github.com/minecraft-linux/mcpelauncher-ui-manifest.git mcpelauncher-ui
  cd ./mcpelauncher-ui/mcpelauncher-ui-qt && git checkout qt6
  cd ./mcpelauncher-ui/playdl-signin-ui-qt && git checkout qt6
  mkdir -p ./mcpelauncher-ui/build
  cd ./mcpelauncher-ui/build && cmake -DCMAKE_INSTALL_PREFIX=/opt/mcpe -DLAUNCHER_CHANGE_LOG="<p>Testing</p>" \
  -DLAUNCHER_VERSIONDB_URL=https://raw.githubusercontent.com/minecraft-linux/mcpelauncher-versiondb/master \
  -DCMAKE_BUILD_TYPE=Release -DQT_VERSION=6 ..
  cd ./mcpelauncher-ui/build && make -j $(nproc --ignore=2)

build-extractor:
  git clone https://github.com/minecraft-linux/mcpelauncher-extract.git -b ng
  mkdir -p ./mcpelauncher-extract/build
  cd ./mcpelauncher-extract/build && cmake -DCMAKE_INSTALL_PREFIX=/opt/mcpe -DBUILD_SHARED_LIBS=NO ..
  cd ./mcpelauncher-extract/build && make -j $(nproc --ignore=2)

deb-extractor:
  cd ./mcpelauncher-extract/build && get-deps ./mcpelauncher-extract >> deps.txt
  cd ./mcpelauncher-extract/build && echo mcpelauncher-extract > description-pak
  cd ./mcpelauncher-extract/build && checkinstall --pkgname mcpelauncher-extract --maintainer ChristopherHX --pkglicense WTFPL --pkgarch amd64 \
  --pkgsource https://github.com/minecraft-linux/mcpelauncher-extract --pkggroup mcpelauncher --nodoc --pkgversion 0.5.0-$(cd .. && git rev-parse --short HEAD) \
  --requires $(sort < deps.txt | uniq | paste -s -d,) --provides mcpelauncher-extract --install=no --fstrans=yes  --default 
  cd ./mcpelauncher-extract/build && cp mcpelauncher-extract*.deb ../../mcpelauncher-extract.deb

install-extractor:
  cd ./mcpelauncher-extract/build && make install

clean:
  rm -rf mcpelauncher-extract
  rm -rf mcpelauncher
  rm -rf mcpelauncher-ui
  rm -f mcpelauncher.deb
  rm -f mcpelauncher-ui.deb
