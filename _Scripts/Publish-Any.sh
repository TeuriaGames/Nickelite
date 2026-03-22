#!/usr/bin/env bash

set -e  

RUNTIME="$1"
CONFIG="$2"

pushd . > /dev/null

cd ..

OUT_DIR="_Publish/${RUNTIME}/${CONFIG}"
mkdir -p "$OUT_DIR"

pushd Nickel > /dev/null
dotnet publish Nickel.csproj \
  -c Release \
  -f "$RUNTIME" \
  -p:PublishReadyToRun=false \
  -p:TieredCompilation=false \
  -p:PublishSingleFile=false \
  -p:UseReferenceAssembly=true \
  -p:OutDir="../$OUT_DIR" \
  --self-contained
popd > /dev/null

build_internal_mod () {
  local runtime="$1"
  local config="$2"
  local project="$3"

  pushd "$project" > /dev/null
  dotnet build "${project}.csproj" \
    -c Release \
    -p:EnableDllReference=false \
    -p:ModLoaderPath="../_Publish/${runtime}/${config}" \
    -p:ModDeployModsPath="../_Publish/${runtime}/${config}/InternalModLibrary"
  popd > /dev/null
}

build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.Bugfixes"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.Essentials"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.InfoScreens"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.Legacy"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.ModSettings"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.UpdateChecks"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.UpdateChecks.GitHub"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.UpdateChecks.NexusMods"
build_internal_mod "$RUNTIME" "$CONFIG" "Nickel.UpdateChecks.UI"

popd > /dev/null