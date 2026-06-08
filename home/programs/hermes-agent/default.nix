{ inputs, pkgs, ... }:

{
  # Hermes Agent (Nous Research) の自律エージェント CLI。
  # full バリアントは音声・画像生成・全 LLM プロバイダを含む別パッケージ出力のため、
  # overlay ではなく公式 flake の packages 出力を直接参照する。
  # LLM プロバイダ等の実行時設定は導入後に `hermes setup` で行う。
  home.packages = [
    inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.full
  ];
}
