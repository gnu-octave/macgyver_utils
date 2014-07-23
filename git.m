function git(varargin)
% git wrapper for gnu octave
% stolen and modified from https://github.com/manur/MATLAB-git/
%
% octave:1> git add git.m
%
% octave:2> git commit -m "test"
% [master c3f9570] test
%  1 file changed, 2 insertions(+), 3 deletions(-)
%
% octave:3> git push origin master
% Counting objects: 18, done.
% Delta compression using up to 2 threads.
% Compressing objects: 100% (15/15), done.
% Writing objects: 100% (17/17), 4.70 KiB | 0 bytes/s, done.
% Total 17 (delta 3), reused 0 (delta 0)
% To https://github.com/markuman/octave-osuv.git
%    a4dbff1..c3f9570  master -> master
%
% octave:4>
%
% Test to see if git is installed
[status,~] = system('git --version');
% if git is in the path this will return a status of 0
% it will return a 1 only if the command is not found

    if (0<status)
        % If GIT Is NOT installed, then this should end the function.
        if ispc
	        fprintf('git is not installed\n Download it at http://git-scm.com/download');
	elseif isunix
		fprintf('Please installd git\n Arch Linux: sudo pacman -S git\n Debian (.deb based): sudo apt-get install git\n Fedora (.rpm based): sudo yum install git\n');
	else fprintf('git is not installed\n Download it at http://git-scm.com/download');
	endif
    else
        % Otherwise we can call the real git with the arguments
        arguments = parse(varargin{:});
        if ispc
          prog = '';
        else
          prog = ' | cat';
        endif
        [~,result] = system(['git ',arguments,prog]);

        % show result
        disp(result)
    endif
endfunction

function sp = parse(varargin)
	sp = cell2mat(cellfun(@(s)(["""",s,""" "]),varargin,'UniformOutput',false));
endfunction
