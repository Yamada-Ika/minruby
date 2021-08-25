# frozen_string_literal: true

require 'minruby'

def evaluate(tree, lenv, genv)
  case tree[0]
  when 'lit'
	  tree[1]
  when '+'
    # lenv["plus_count"] += 1
	  evaluate(tree[1], lenv, genv) + evaluate(tree[2], lenv, genv)
  when '-'
	  evaluate(tree[1], lenv, genv) - evaluate(tree[2], lenv, genv)
  when '*'
	  evaluate(tree[1], lenv, genv) * evaluate(tree[2], lenv, genv)
  when '/'
	  evaluate(tree[1], lenv, genv) / evaluate(tree[2], lenv, genv)
  when '%'
	  evaluate(tree[1], lenv, genv) % evaluate(tree[2], lenv, genv)
  when '**'
	  evaluate(tree[1], lenv, genv) ** evaluate(tree[2], lenv, genv)
  when '=='
	  evaluate(tree[1], lenv, genv) == evaluate(tree[2], lenv, genv)
  when '!='
	  evaluate(tree[1], lenv, genv) != evaluate(tree[2], lenv, genv)
  when '>'
	  evaluate(tree[1], lenv, genv) > evaluate(tree[2], lenv, genv)
  when '>='
	  evaluate(tree[1], lenv, genv) >= evaluate(tree[2], lenv, genv)
  when '<'
	  evaluate(tree[1], lenv, genv) < evaluate(tree[2], lenv, genv)
  when '<='
	  evaluate(tree[1], lenv, genv) <= evaluate(tree[2], lenv, genv)
  when '&&'
	  evaluate(tree[1], lenv, genv) && evaluate(tree[2], lenv, genv)
  when 'func_def'
    genv[tree[1]] = ['user_defined', tree[2], tree[3]]
  when 'func_call'
    args = []
    i = 0
    while tree[i + 2]
      args[i] = evaluate(tree[i + 2], lenv, genv)
      i = i + 1
    end
    mhd = genv[tree[1]]
    if mhd[0] == 'builtin'
      minruby_call(mhd[1], args)
    else
      new_lenv = {}
      params = mhd[1]
      i = 0
      while params[i]
        new_lenv[params[i]] = args[i]
        i = i + 1
      end
      evaluate(mhd[2], new_lenv, genv)
    end
  when 'var_assign'
    lenv[tree[1]] = evaluate(tree[2], lenv, genv)
  when 'var_ref'
    lenv[tree[1]]
  when 'ary_new'
    ary = []
    i = 1
    while tree[i]
      ary[i - 1] = evaluate(tree[i], lenv, genv)
      i = i + 1
    end
    ary
  when 'ary_assign'
    evaluate(tree[1], lenv, genv)[evaluate(tree[2], lenv, genv)] = evaluate(tree[3], lenv, genv)
  when 'ary_ref'
    evaluate(tree[1], lenv, genv)[evaluate(tree[2], lenv, genv)]
  when 'hash_new'
    hsh = {}
    i = 1
    while tree[i]
      hsh[evaluate(tree[i], lenv, genv)] = evaluate(tree[i + 1], lenv, genv)
      i = i + 2
    end
    hsh
  when 'if'
    if evaluate(tree[1], lenv, genv)
      evaluate(tree[2], lenv, genv)
    else
      evaluate(tree[3], lenv, genv)
    end
  when 'while'
    while evaluate(tree[1], lenv, genv)
      evaluate(tree[2], lenv, genv)
    end
  when 'while2'
    evaluate(tree[2], lenv, genv)
    while evaluate(tree[1], lenv, genv)
      evaluate(tree[2], lenv, genv)
    end
  when 'stmts'
    i = 1
    last = nil
    while tree[i] != nil
      last = evaluate(tree[i], lenv, genv)
      i = i + 1
    end
    last
  else
    p 'error'
    pp tree
    raise 'unknown code'
  end
end

str = minruby_load()
# pp str
tree = minruby_parse(str)
# pp tree
genv = {
  'p' => ['builtin', 'p'],
  'raise' => ['builtin', 'raise'],
  'require' => ['builtin', 'require'],
  'minruby_parse' => ['builtin', 'minruby_parse'],
  'minruby_load' => ['builtin', 'minruby_load'],
  'minruby_call' => ['builtin', 'minruby_call']
}
lenv = {}
evaluate(tree, lenv, genv)
# pp lenv, genv
