# Welcome to the party, pal

## Running and debugging applications and tests

It turns out that we owe a shit ton of thanks to the microsoft and vscode teams for building something called the [Debug Adaptor Protocol](https://microsoft.github.io/debug-adapter-protocol/), which is essentially what modern IDE debugging is based off of. If you've used vscode, you'll be familiar with the `launch.json` file. Even though we're using neovim, we'll be using the same protocol, and the end result will feel familiar to debugging in vscode.

By the way, if you're new to this world, this is a great starting point: [nvim-basic-ide](https://github.com/LunarVim/nvim-basic-ide)

## Base Requirements
[neovim >= 0.7](https://neovim.io) -- Well, yeah. You'll need that one.  
[packer](https://github.com/wbthomason/packer.nvim) -- neovim package management  
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) -- Quickstart configs for nvim LSP  
[mason](https://github.com/williamboman/mason.nvim) -- LSP package manager, etc  
[mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim) -- Bridges the gap between lspconfig and mason  

### Debug stuff
[nvim-dap](https://github.com/mfussenegger/nvim-dap) -- Debug Adaptor Protocol implementation for Neovim  
[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) -- A nice and familiar looking UI for debugging  

#### TS/JS
[jester](https://github.com/David-Kunz/jester) -- run end debug jest tests  
[vscode-js-debug](https://github.com/microsoft/vscode-js-debug) -- Microsoft's JS debugger  
[nvim-dap-vscode-js](https://github.com/mxsdev/nvim-dap-vscode-js) -- adapt vscode-js-debug for nvim-dap  


#### Python
[nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python) -- snakey go hisssss



# OK Let's a go
## Python
First off, we're gonna need a python debugger, and we're gonna want it tucked away in a virtual environment because python.
Using pipenv and python 3.9.7:
```
cd ~/.config/nvim
mkdir debug && cd debug
mkdir debugpy && cd debugpy
pipenv install 3.9.7
pipenv install debugpy
pipenv run which python

```
That last step, `pipenv run which python` has foolishly told you its deepest darkest secret: Where to find the python environment with the debugger installed. We're gonna use that.  

Pop into wherever you configure your DAP stuff. Is it `dap.lua`? Probably. Let's set up `dap-python`, tell it that we like to use `pytest` when we run tests, and tell it where our `debugpy` environment lives in the `setup` method.
```
local vscode_ok, vscode = pcall(require, "dap.ext.vscode")
if not vscode_ok then
  return
end

local dap_python_status_ok, dap_python = pcall(require, "dap-python")
if not dap_python_status_ok then
  return
end

-- set pytest as desired test runner
dap_python.test_runner = "pytest"
-- Install an environment with debugpy and point to the binary
dap_python.setup("~/.local/share/virtualenvs/debugpy-1pX4fgu6/bin/python")
-- rather than dump a bunch of configs here, use the .vscode/launch.json file in the repo to provide launch options
vscode.load_launchjs()

```
`dap-python` is super smart in that it will use the supplied environment to run `debugpy` but will also detect your current environment with the `VIRTUAL_ENV` environment variable to ensure you have access to all your cool packages etc.
That last line is fucking magic. Rather than literally configuring every conceivable run configuration for all of your projects in one lua file, we get to use those `launch.json` files. Here's one that's tucked inside my work repo `inspections-service` at `inspections-service/.vscode/launch.json` because your name is Chaz and this is relevant to you (this is a sample for a very specific Flask project):
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Flask",
            "type": "python",
            "request": "launch",
            "module": "flask",
            "env": {
                "FLASK_APP": "built_inspections_http/app.py",
                "FLASK_DEBUG": "1",
                "LOCAL_SERVICE_URL_PREFIX": "/inspections"
            },
            "args": [
                "run",
                "-p 5001"
            ],
            "jinja": true,
            "justMyCode": true
        }
  ]
}
```

OK we should be done. Close Neovim, navigate to a python project, activate the shell (perhaps `pipenv shell`?) and enter Neovim again.

1. Run/Debug the app!
For example, you wanna use Postman to hit an API endpoint and pause mid-way. Go to a line you want to pause at and insert a debug point (lots of packages map this to `<leader>db`): `:lua require('dap').toggle_breakpoint()`.
Now run the app with (often shortcut to `<leader>dc`) `:lua require('dap').continue()`  

OK, so if you're `launch.json` is configured correctly (out of scope for this walkthrough), your app is running in debug mode. Hit that route in Postman and watch your new debugging IDE do its thing!

2. Run/Debug a test!
Go to a simple unit test that you know will pass. Run `:lua require('dap-python').test_method()`. I mapped that to `<leader>tt` for "run nearest test to cursor". You can drop a breakpoint like above to debug that test.
