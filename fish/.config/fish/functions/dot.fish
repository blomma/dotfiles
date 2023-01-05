function dot --wraps='git --git-dir=/Users/blomma/.dot --work-tree=/Users/blomma' --description 'alias dot=git --git-dir=/Users/blomma/.dot --work-tree=/Users/blomma'
  git --git-dir=/Users/blomma/.dot --work-tree=/Users/blomma $argv; 
end
