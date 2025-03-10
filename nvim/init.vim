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


local function fix_bib_entries()
    -- Define conference mappings directly in Lua
    local conf_map = {
        symposiumondiscretealgorithms = "Symposium on Discrete Algorithms (SODA)",
        symposiumontheoryofcomputing = "Symposium on Theory of Computing (STOC)",
        symposiumonthetheoryofcomputing = "Symposium on Theory of Computing (STOC)",
        foundationsofcomputerscience = "Foundations of Computer Science (FOCS)",
        automatalanguagesandprogramming = "International Colloquium on Automata, Languages, and Programming (ICALP)",
        europeansymposiumonalgorithms = "European Symposium on Algorithms (ESA)",
        approximationrandomizationandcombinatorialopt = "APPROX/RANDOM",
        principlesofdistributedcomputing = "Principles of Distributed Computing (PODC)",
        simplicityinalgorithms = "Symposium on Simplicity in Algorithms (SOSA)",
        neuralinformationprocessingsystems = "Advances in Neural Information Processing Systems (NeurIPS)",
        parameterizedandexactcomputation = "Symposium on Parameterized and Exact Computation (IPEC)",
        symposiumontheoreticalaspectsofcomputerscience = "Symposium on Theoretical Aspects of Computer Science (STACS)",
        symposiumondistributedcomputing = "Symposium on Distributed Computing (DISC)",
        internationalconferenceonmachinelearning = "International Conference on Machine Learning (ICML)",
        theoryandapplicationsofmodelsofcomputation = "Theory and Applications of Models of Computation (TAMC)",
        theoryofcryptography = "Theory of Cryptography (TCC)",
        economicsandcomputation = "Conference on Economics and Computation (EC)",
        theoryandapplicationofcryptologyandinformationsecurity = "Theory and Application of Cryptology and Information Security (ASIACRYPT)",
        conferenceonlearningtheory = "Conference on Learning Theory (COLT)",
        meetingonanalyticalgorithmicsandcombinatorics = "Meeting on Analytic Algorithmics and Combinatorics (ANALCO)",
        foundationsofsoftwaretechnology = "Foundations of Software Technology and Theoretical Computer Science (FSTTCS)",
        worldwidewebconference = "World Wide Web Conference (WWW)",
        approximationalgorithmsforcombinatorialoptimization = "Approximation Algorithms for Combinatorial Optimization (APPROX)"
    }

    -- Function to normalize booktitle: keep only alphabetic characters and convert to lowercase
    local function normalize_booktitle(booktitle)
        return booktitle:gsub("[^a-zA-Z]", ""):lower()
    end

    -- Get buffer lines
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local new_lines = {}
    local booktitle_line = nil

    for _, line in ipairs(lines) do
        local trimmed = line:match("^%s*(.-)%s*$")  -- Trim whitespace

        -- Remove unwanted fields
        if trimmed:match("^bibsource%s*=") or trimmed:match("^timestamp%s*=") then
            goto continue
        end

        -- Detect booktitle
        if trimmed:match("^booktitle%s*=") then
            booktitle_line = line
        end

        table.insert(new_lines, line)

        -- Fix booktitle if necessary
        if booktitle_line then
            local key = booktitle_line:match('booktitle%s*=%s*{(.-)}')
            if key then
                local normalized = normalize_booktitle(key)
                if conf_map[normalized] then
                    local fixed = "booktitle = {" .. conf_map[normalized] .. "},"
                    new_lines[#new_lines] = fixed  -- Replace last entry
                end
            end
            booktitle_line = nil  -- Reset
        end

        ::continue::
    end

    -- Replace buffer content
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
    print("BibTeX cleaned and booktitle fixed!")
end

-- Command to call in Neovim
vim.api.nvim_create_user_command("FixBib", fix_bib_entries, {})
EOF
