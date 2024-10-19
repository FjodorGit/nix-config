local ls = require 'luasnip'
local snip = ls.snippet
local text = ls.text_node
local ins = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

-- greeks
local alpha = snip({ trig = ';a', snippetType = 'autosnippet' }, { text '\\alpha' })
local beta = snip({ trig = ';b', snippetType = 'autosnippet' }, { text '\\beta' })
local gamma = snip({ trig = ';g', snippetType = 'autosnippet' }, { text '\\gamma' })

local fraction = snip({ trig = 'ff', dscr = 'Expands fraction' }, {
  text '\\frac{',
  ins(1),
  text '}{',
  ins(2),
  text '}',
})

local environment = snip(
  { trig = 'env', snippetType = 'autosnippet' },
  fmta(
    [[
      \begin{<>}
          <>
      \end{<>}
    ]],
    {
      ins(1),
      ins(2),
      rep(1), -- this node repeats insert node i(1)
    }
  )
)

return {
  alpha,
  beta,
  gamma,
  fraction,
  environment,
}
