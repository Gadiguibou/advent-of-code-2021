⎕IO ← 0
input ← ⍎ ⍞
⍝ Find the range of possible values for the optimal distance
⎕IO ← ⌊/input
range ← ⍳ 1 + ⌈/input
⍝ Revert any potential side effect
⎕IO ← 0
⍝ This is a hack
⍝ I'm not sure how to generate a range without having a side effect on array indexing
⍝ Maybe this?
⍝ range_inclusive ← {tmp ← ⎕IO ⋄ ⎕IO ← ⍺ ⋄ ⍳ 1 + ⍵ ⋄ ⎕IO ← tmp}
triangular_number ← {((⍵+1)×⍵)÷2}
cost ← ⌊/+/triangular_number¨|range ∘.- input
⍞ ← ⍕ cost
