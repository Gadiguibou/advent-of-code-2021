⎕IO ← 0 
input ← ⍎ ⍞
median ← {(⍵[⍋⍵])[⌊0.5×⍴⍵]} input
cost ← median {+/|⍺-⍵} input
⍞ ← ⍕ cost
