# My-GPT

## Setup

1. Install [uv](https://docs.astral.sh/uv/) once:

   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. From the repo folder, create the virtual env and install the packages.
   uv reads `.python-version` and downloads Python 3.14 if needed.

   ```bash
   uv venv
   uv pip install -r requirements.txt
   ```

3. In VS Code: `Cmd+Shift+P` > "Python: Select Interpreter" > pick `.venv`.

Run `uv pip install -r requirements.txt` again whenever `requirements.txt`
changes.

## Journal
