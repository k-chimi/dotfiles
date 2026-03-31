{ runCommand }:
  runCommand "kchimi-shell-ps1-prompt-command" {
    src = ./.;
  } ''
    mkdir $out
    cp $src/prompt_command.sh $out/__prompt_command
    chmod +x $out/__prompt_command
  ''
        
