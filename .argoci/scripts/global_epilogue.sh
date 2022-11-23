# No set -e so that we continue to collect artifacts even if some fail.
set -x

# set nullglob so that '*' is not used literally if the artifacts dir is empty
shopt -s nullglob

cd "${REPO_DIR}"

my_dir=$(dirname "$0")
repo_dir=$my_dir/..

cd "$repo_dir/artifacts" || exit 1

for file in *; do
  gsutil cp "$file" "${CI_ARTIFACT_STEP_STORAGE}/$file"
done