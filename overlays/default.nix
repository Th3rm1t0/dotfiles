{ inputs, ... }:

{
  claude-code = inputs.claude-code.overlays.default;
  herdr = inputs.herdr.overlays.default;
}
