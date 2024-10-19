local ls = require 'luasnip'
local snip = ls.snippet
local text = ls.text_node
local ins = ls.insert_node
local fmta = require('luasnip.extras.fmt').fmta
local rep = require('luasnip.extras').rep

local matrix = snip({ trig = 'mat' }, {
  ins(1, 'A'),
  text ' \\in \\mathbb{R}^{',
  ins(2, 'n'),
  text ' \\times n}',
})
local markdownMathEnv = snip({ trig = ' mm', snippetType = 'autosnippet' }, {
  text '$$',
  ins(1),
  text '$$',
})
local setX = snip({ trig = 'setx' }, {
  text '$',
  ins(1, 'X'),
  text ' \\subseteq \\mathbb{R}^{n}$',
})
local set = snip({ trig = 'set' }, {
  text '\\left\\{',
  ins(1),
  text '\\right\\}',
})
-- greeks
local alpha = snip({ trig = ';a', snippetType = 'autosnippet' }, { text '\\alpha' })
local beta = snip({ trig = ';b', snippetType = 'autosnippet' }, { text '\\beta' })
local gamma = snip({ trig = ';g', snippetType = 'autosnippet' }, { text '\\gamma' })
local lambda = snip({ trig = ';l', snippetType = 'autosnippet' }, { text '\\lambda' })

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

local polyhedra = snip({ trig = '\\pol' }, {
  text 'P^{\\leq}(',
  ins(1, 'A'),
  text ',',
  ins(2, 'b'),
  text ')',
})

local R = snip({ trig = ';R', snippetType = 'autosnippet' }, {
  text '\\mathbb{R}^{',
  ins(1, 'n'),
  text '}',
})

local Z = snip({ trig = ';Z', snippetType = 'autosnippet' }, {
  text '\\mathbb{Z}^{',
  ins(1, 'n'),
  text '}',
})

return {
  alpha,
  beta,
  gamma,
  lambda,
  fraction,
  environment,
  polyhedra,
  R,
  Z,
  setX,
  set,
  markdownMathEnv,
  matrix,
}
