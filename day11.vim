function! Add(f, n, x)
  let a:f[a:n] = get(a:f, a:n, 0) + a:x
endfunction

function! Solve(k, freq)
  let acc = a:freq
  for _ in range(a:k)
    let res = {}
    for [n_str, n_freq] in items(acc)
      let n = str2nr(n_str)
      if n == 0
        call Add(res, 1, n_freq)
      elseif strlen(n_str) % 2 == 0
        let k = strlen(n_str)/2
        call Add(res, str2nr(n_str[:k-1]), n_freq)
        call Add(res, str2nr(n_str[k:]), n_freq)
      else
        call Add(res, n*2024, n_freq)
      endif
    endfor
    let acc = res
  endfor
  return eval(join(values(acc), '+'))
endfunction

let input = readfile("input/input11.txt")
let nums = map(split(join(input, " "), " "), 'str2nr(v:val)')
let freq = {}
for n in nums
  call Add(freq, n, 1)
endfor

let Run = function("Solve")
echo Run(25, freq)
echo Run(75, freq)

