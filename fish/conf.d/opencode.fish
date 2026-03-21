# Workaround for light theme code diff visibility bug in opencode
#
# See: https://github.com/anomalyco/opencode/issues/16470
# See: https://github.com/anomalyco/opencode/issues/17935
set -gx OPENCODE_EXPERIMENTAL_MARKDOWN false
