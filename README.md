# Template repository for Dev 2.0 ✨ dotfiles

Use this template to start developing your dotfiles. 💪

Create the new repo in your GitHub user account as `your-username/dotfiles`. Once created, follow the [dotfiles guide for your IDE](https://docs.wayflyer.io/wf-devcontainer/latest/ide.html).

## Customizing your devcontainer

Once configured, on any future launch of a devcontainer your repo will be cloned into the container and the contents of `dotfiles` will be symlinked into the `$HOME` directory.

Customize your container easily by:

- Adding new scripts to `dotfiles/.local/bin`.
- Adding other dotfiles and dotdirs (e.g. `.zshrc`) to `dotfiles/`.

More advanced customizations are possible by editing the `install` script to change or extend the installation behavior.


## Oh-my-zsh?

To install [oh-my-zsh](https://ohmyz.sh/) into your dotfiles repo:

1. Clone your dotfiles project into a dev container.

2. [Install oh-my-zsh](https://ohmyz.sh/#install).

3. Copy the generated `.zshrc` file to `dotfiles/`.

    ```
    cp ~/.zshrc dotfiles/
    ```

4. Add the oh-my-zsh repo as a subtree in your workspace with:

    ```
    git subtree add --prefix dotfiles/.oh-my-zsh https://github.com/ohmyzsh/ohmyzsh master --squash
    ```

4. If using VS Code, update your `settings.json` with:

    ```
    "terminal.integrated.defaultProfile.osx": "zsh",
    "terminal.integrated.defaultProfile.linux": "zsh"
    ```

   If using [`wfx`](https://docs.wayflyer.io/wf-cli-plugin-x/latest/) or [prod access environment](https://github.com/wayflyer/wayflyer/blob/master/prodaccessenv/README.md), add the following to your `docker-compose.override.yml`:

   ```
   services:
     dev:
       environment:
         - SHELL=zsh
    ```
