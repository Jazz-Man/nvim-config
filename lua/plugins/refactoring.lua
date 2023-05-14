local m = require'jz.utils.keybinding'.map
local c = require'jz.utils.keybinding'.cmd

return {
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },

    config = function( _, opts )

      require('refactoring').setup(opts)

      m:group(
        { prefix = '<localleader>r', desc = 'Refactoring' }, function()

          -- Remaps for the refactoring operations currently offered by the plugin

          m:vnoremap():desc('Extract Function'):k('e'):c(
            c:lua(
              'refactoring', [[ refactor('Extract Function') ]]
            )
          )

          m:vnoremap():desc('Extract Function To File'):k('f'):c(
            c:lua(
              'refactoring', [[ refactor('Extract Function To File') ]]
            )
          )

          m:vnoremap():desc('Extract Variable'):k('v'):c(
            c:lua(
              'refactoring', [[ refactor('Extract Variable') ]]
            )
          )

          m:vnoremap():desc('Inline Variable'):k('i'):c(
            c:lua(
              'refactoring', [[ refactor('Inline Variable') ]]
            )
          )

          -- Extract block doesn't need visual mode

          m:nnoremap():desc('Extract Block'):k('b'):c(
            c:lua(
              'refactoring', [[ refactor('Extract Block') ]]
            )
          )

          m:nnoremap():desc('Extract Block To File'):k('bf'):c(
            c:lua(
              'refactoring', [[ refactor('Extract Block To File') ]]
            )
          )

          -- Inline variable can also pick up the identifier currently under the cursor without visual mode
          m:nnoremap():desc('Inline Variable'):k('i'):c(
            c:lua(
              'refactoring', [[ refactor('Inline Variable') ]]
            )
          )

        end
      )

    end
  }
}
