# 🐛 Troubleshooting Guide

This guide covers common issues and their solutions.

## Parse Errors

### Error: `defining function based on alias`

**Error message:**
```
/home/user/.zshrc:XXX: defining function based on alias `functionname'
/home/user/.zshrc:XXX: parse error near `()'
```

**Cause:** You have both an alias and a function with the same name.

**Solution:**

1. Open `.zshrc`:
```bash
nano ~/.zshrc
```

2. Find the conflicting function and rename it:
```bash
# OLD (❌ Wrong)
gbr() {
  git checkout -b "$1"
}

# NEW (✅ Correct)
create_branch() {
  git checkout -b "$1"
}
```

3. Also remove the alias if it exists:
```bash
# Find and remove or comment out:
# alias gbr='...'
```

4. Save and reload:
```bash
source ~/.zshrc
```

---

## Symbol/Character Issues

### Issue: Symbols not displaying correctly (boxes or question marks)

**Example:**
```
? ~ ❯ │ ● instead of ╭ ~ ● ╰
```

**Cause:** Terminal font doesn't support Unicode characters.

**Solution:**

1. Install a compatible font:
```bash
sudo apt install fonts-fira-code
# or
sudo apt install fonts-jetbrains-mono
# or
sudo apt install fonts-cascadia-code
```

2. Change terminal font:
   - **GNOME Terminal**: Edit → Preferences → Text → Font
   - **Konsole**: Settings → Edit Current Profile → Appearance → Font
   - **Terminator**: Right-click → Preferences → Appearance → Font
   - **xterm**: Edit `~/.Xresources` and add `XTerm*font: -misc-fixed-medium-r-*-*-14-*-*-*-*-*-*-*`

3. Restart terminal

---

## Performance Issues

### Issue: Terminal takes long time to start

**Cause:** Too many plugins or expensive operations.

**Solution:**

1. Check startup time:
```bash
time zsh -i -c exit
```

2. Disable heavy plugins in `~/.zshrc`:
```bash
plugins=(
  git                # Keep essential ones
  npm
  zsh-autosuggestions
  # Disable others temporarily
)
```

3. Disable git branch detection for large repos:
```bash
# In ~/.zshrc, comment out or optimize:
git_branch_info() {
    # return ""  # Temporarily disable
}
```

4. Reload:
```bash
source ~/.zshrc
```

---

## Git Integration Issues

### Issue: Git branch not showing

**Solution:**

1. Check if git is installed:
```bash
git --version
```

2. Make sure you're in a git repository:
```bash
git status
```

3. Verify the function is not commented:
```bash
# Check .zshrc for:
# git_branch_info() {
#     ...
# }
# Remove the # if commented
```

### Issue: Git status slow in large repositories

**Solution:**

1. Disable real-time git status:
```bash
# In ~/.zshrc, modify:
git_status_icon() {
    return ""  # Disable
}
```

2. Or use a submodule to ignore:
```bash
cd /path/to/large/repo
git config --local status.showUntrackedFiles no
```

---

## Color Issues

### Issue: Colors look weird or are missing

**Cause:** Terminal color support or TERM variable not set correctly.

**Solution:**

1. Check TERM variable:
```bash
echo $TERM
# Should show: xterm-256color or screen-256color
```

2. If not, add to `~/.zshrc`:
```bash
export TERM=xterm-256color
```

3. Reload:
```bash
source ~/.zshrc
```

### Issue: Prompt text is hard to read

**Solution:** Customize colors in `~/.zshrc`

```bash
# Find the PROMPT section and change colors:
# magenta → Try: cyan, blue, green, yellow, white
# green → Try: cyan, white, yellow
# cyan → Try: magenta, white, yellow

PROMPT='%F{cyan}╭─%f %F{white}%n%f%F{green}@%f%F{blue}%m%f ...'
```

Valid colors: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`

---

## Aliases Not Working

### Issue: Alias not recognized

**Cause:** Typo in alias definition or not reloaded.

**Solution:**

1. Check alias is defined:
```bash
alias | grep youraliasname
```

2. If not found, add it to `~/.zshrc`:
```bash
alias yourname='command here'
```

3. Reload:
```bash
source ~/.zshrc
```

4. Test:
```bash
yourname
```

### Issue: Alias conflicts with built-in command

**Example:** If you name an alias `ls`, it will hide the real `ls`.

**Solution:** Use a different name:
```bash
# Instead of:
alias ls='ls -lah'

# Use:
alias la='ls -lah'
```

---

## Oh My Zsh Issues

### Issue: Oh My Zsh not loading

**Solution:**

1. Check if Oh My Zsh is installed:
```bash
ls -la ~/.oh-my-zsh
```

2. If not, install it:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

3. Verify `~/.zshrc` contains:
```bash
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
```

### Issue: Plugins not loading

**Solution:**

1. Check plugins are installed:
```bash
ls ~/.oh-my-zsh/custom/plugins/
```

2. Verify plugins in `~/.zshrc`:
```bash
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)
```

3. Install missing plugins:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-completions \
  ~/.oh-my-zsh/custom/plugins/zsh-completions
```

4. Reload:
```bash
source ~/.zshrc
```

---

## Restore to Backup

If something goes wrong, restore your backup:

```bash
# Check if backup exists
ls -la ~/.zshrc.backup

# Restore
cp ~/.zshrc.backup ~/.zshrc

# Reload
source ~/.zshrc
```

---

## Get Help

If your issue isn't listed here:

1. **Check the logs:**
```bash
zsh -x  # Run with debugging
exit    # Return to normal
```

2. **Test individual components:**
```bash
# Test git functions
git_branch_info

# Test aliases
which youraliasname
```

3. **Report the issue:**
   - Visit: [GitHub Issues](https://github.com/yourusername/zsh-pro-terminal/issues)
   - Include:
     - Your OS version (`lsb_release -a`)
     - ZSH version (`zsh --version`)
     - Terminal application name
     - Error messages (exact text)
     - Steps to reproduce

---

## Quick Reset

If everything is broken:

```bash
# Reset to default
rm ~/.zshrc
cp ~/.zshrc.backup ~/.zshrc

# Or start fresh
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

**Still having issues?** Open an issue on GitHub or join our Discord community!
