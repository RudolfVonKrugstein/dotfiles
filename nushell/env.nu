# set nvim as editor
$env.EDITOR = "nvim"

# add luarocks to path
if (which luarocks | is-not-empty) {
  luarocks path --bin | lines | parse "export {var}='{value}'" | transpose -i -r -d | load-env
}

# add ~/.cargo/bin to path
if ($env.HOME | path join ".cargo" "bin" | path exists) {
  $env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | path join ".cargo" "bin"))
}

# add ~/.nix-profile/bin
if ($env.HOME | path join ".nix-profile" "bin" | path exists) {
  $env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | path join ".nix-profile" "bin"))
}

# add .local/bin
if ($env.HOME | path join ".local" "bin" | path exists) {
  $env.PATH = ($env.PATH | split row (char esep) | append ($env.HOME | path join ".local" "bin"))
}

# add /usr/local/cuda/bin
if ("/usr/local/cuda/bin" | path exists) {
  $env.PATH = ($env.PATH | split row (char esep) | append "/usr/local/cuda/bin")
}

# oh-my-osh
mkdir ~/.cache/oh-my-posh/
oh-my-posh init nu  --config ~/dotfiles/oh-my-posh.yaml --print | save -f ~/.cache/oh-my-posh/init.nu

# zoxide
mkdir ~/.cache/zoxide
zoxide init nushell | save -f ~/.cache/zoxide/init.nu

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# keychain/ssh-agent
keychain --eval --quiet
    | lines
    | where not ($it | is-empty)
    | parse "{k}={v}; export {k2};"
    | select k v
    | transpose --header-row
    | into record
    | load-env
