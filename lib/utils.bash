#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/purescript/spago"

fail() {
  echo -e "asdf-spago: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/[0-9].*' | cut -d/ -f3-
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename bin url
  version="$1"
  filename="$2"

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    bin="linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # spago release artifacts have changed names over time for macOS.
    #
    # - "osx.tar.gz" up to and including 0.17.0 (other than a few exceptions)
    # - "macOS-latest.tar.gz" for 0.18.0
    # - "macOS.tar.gz" for 0.18.1 onwards (up to 0.19.0 as of this writing)
    #
    # There are a few other outlier versions which might not be handled here, and the very
    # early versions don't seem to contain an executable named "spago" so those don't work either.
    #
    # See https://github.com/purescript/spago/releases for release artifact filenames
    major_version=$(echo $version | cut -d'.' -f1)
    minor_version=$(echo $version | cut -d'.' -f2)
    if [[ "$version" == "0.18.0" ]]; then
      bin="macOS-latest"
    elif (($major_version == 0 && $minor_version < 18)); then
      bin="osx"
    else
      bin="macOS"
    fi
  else
    fail "unrecognized operating system $OSTYPE"
  fi

  url="$GH_REPO/releases/download/${version}/${bin}.tar.gz"

  echo "* Downloading spago release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-spago supports release installs only"
  fi

  local release_file="$install_path/spago-$version.tar.gz"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"
    tar -xzf "$release_file" -C "$install_path" || fail "Could not extract $release_file"
    mv $install_path/spago $install_path/bin
    rm "$release_file"

    test -x "$install_path/bin/spago" || fail "Expected $install_path/bin/spago to be executable."

    echo "spago $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing spago $version."
  )
}
