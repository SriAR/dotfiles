set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

lua << EOF
require('nvim-treesitter.configs').setup {
    ensure_installed = { "haskell", "cpp", "c", "javascript", "markdown" },
    highlight = { -- Be sure to enable highlights if you haven't!
        enable = true,
    }
}

local function append_bib_entry()
  local pubs_list = os.getenv("HOME") .. "/pubs/pubs.list"

  -- Check if pubs.list exists
  if vim.fn.filereadable(pubs_list) == 0 then
    print("Error: pubs.list file not found at " .. pubs_list)
    return
  end

  -- Read lines from pubs.list
  local lines = {}
  for line in io.lines(pubs_list) do
    table.insert(lines, line)
  end

  if #lines == 0 then
    print("Error: No entries found in pubs.list")
    return
  end

  -- Use fzf-lua to select a line
  require("fzf-lua").fzf_exec(lines, {
    prompt = "Select a publication > ",
    actions = {
      ["default"] = function(selected)
        local line = selected[1] -- Get the selected line
        local key = line:match("%[(.-)%]") -- Extract text inside []

        if not key then
          print("Error: No valid key found in the selected line")
          return
        end

        local bib_file = os.getenv("HOME") .. "/pubs/bib/" .. key .. ".bib"

        -- Check if the BibTeX file exists
        if vim.fn.filereadable(bib_file) == 0 then
          print("Error: BibTeX file not found: " .. bib_file)
          return
        end

        -- Determine Ref.bib location (current or parent directory)
        local ref_bib = "Ref.bib"
        if vim.fn.filereadable(ref_bib) == 0 then
          ref_bib = "../Ref.bib" -- Check parent directory
          if vim.fn.filereadable(ref_bib) == 0 then
            print("Error: No Ref.bib found in current or parent directory")
            return
          end
        end

        -- Append the contents of the .bib file
        local cmd = "cat " .. bib_file .. " >> " .. ref_bib
        os.execute(cmd)
        print("Appended " .. bib_file .. " to " .. ref_bib)
      end,
    },
  })
end

-- Create a Neovim command for this function
vim.api.nvim_create_user_command("AppendBib", append_bib_entry, {})
EOF
