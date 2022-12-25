\NeedsTeXFormat{LaTeX2e}
% Configure the class name and the version to avoid any redundancies
\def\sp@class@name{uulm/sp/article}
\def\sp@class@version{1.0.0}
\ProvidesClass{\sp@class@name}[2021/01/30 Version \sp@class@version]

% we could use kvoptions, but it is another package,
% so i used the default macros
\DeclareOption{sf-font}{\renewcommand\familydefault{\sfdefault}}
\DeclareOption{rm-font}{\renewcommand\familydefault{\rmdefault}}

% enable / disable the automatic usage of fira (sans) font
\newif\if@sp@usefira@
\DeclareOption{usefira}{\@sp@usefira@true}\DeclareOption{nofira}{\@sp@usefira@false}

% enable / disable the automatic usage of helvetica font
\newif\if@sp@usehelvet@
\DeclareOption{usehelvetica}{\@sp@usehelvet@true}\DeclareOption{nohelvetica}{\@sp@usehelvet@false}

% option to switch to a simple title (used by the documentation)
\newif\if@sp@simpletitle@
\DeclareOption{simple-title}{\@sp@simpletitle@true}\DeclareOption{complex-title}{\@sp@simpletitle@false}
% any unknown option will be passed on to the options of scrartcl
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{scrartcl}}

% defaults; i have omitted any defaults
% and moved them to the document.tex
% \ExecuteOptions{}
\ProcessOptions\relax

% We use the koma artical class with a default font size of 11pt
% as requested, the margins have been adapted by using DIV=14
\LoadClass[oneside, fontsize=11pt, DIV=14]{scrartcl}

%%%%	Features	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% - integrate usual exam IDs and names but also enable to customize it
% - integrate adaptability of license
%   - CC0, CC BY, ...
%   - Restricted
%
%
%%%%	Future Features		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	- multilanguage titlepages for English and German
%	- broad selection of CC licenses


\RequirePackage[T1]{fontenc} % load before inputenc
\RequirePackage[utf8]{inputenc}
% used to define a parindent of 0 and an appropriate parskip
% while this package has its problems with the komascript class,
% it works and is the easiest option
\RequirePackage{parskip}

%%%	Language
% Note: language default are inherited by those of the documentclass
\RequirePackage{babel}

%%%	Fonts and general typesetting
\RequirePackage{microtype,fontawesome}

% Font selection (by package options)
\if@sp@usefira@
\if@sp@usehelvet@
\ClassError{\sp@class@name}{You can not use fira and helvetica as main fonts.}{%
Please choose either 'usefira' or 'usehelvetica' but not both. Note: you may choose none of them to use a custom font, if desired.}\fi
\RequirePackage{FiraSans}
\else
\if@sp@usehelvet@
\RequirePackage[scaled]{helvet}
\fi\fi

%%%	Hyperlinks
\AtEndPreamble{%
\RequirePackage{hyperref}
\urlstyle{same} % urls shoould not use a different fontstyle
% Note: This line escapes the protection mechanism of translations
% and allows the title, the authors, ... to be set in the pdf metadata
% (even if they are decoreated or protected)
{\sp@translatelet\@and{and}\def\and{\@and\space}\def\href#1#2{#2}\protected@xdef\@meta@author{\@author}}
\hypersetup{
	pdfborder={0 0 0}, % no pdf border
	colorlinks, % links should have colors
	unicode, % unicode enabled
	breaklinks, % links may break on line ends etc.
	allcolors=cs-red, % default link color
	pdftitle={\@documentType\ - \@title},%
	pdfauthor={\@meta@author}%
}}

%%%	Images and Graphs
\RequirePackage{tikz,graphicx}

%%%	Colors
% Note: xcolor will be loaded by tikz already. tikz is a monster :D
\definecolor{cs-red}{HTML}{A32638}
\definecolor{uulm-blue}{HTML}{A32638}


%%%	enumerates
\RequirePackage{enumitem}
% example of configuration
% \setlist[itemize,1]{label=\color{cs-red}\textbullet}


%%%	Additional Packages
% used for getting 'nth' etc (english semester number)
\RequirePackage[super]{nth}
% used to translate fields and titles
\RequirePackage{translator}
% supplies us with general programming macros :D
\RequirePackage{etoolbox}

%%%	Custom Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% basic wrappers for the translation macros
% they automatically handle prefixes and may be changed to support
% different translation packages
\def\sp@translate#1{\translate{sp@translations@#1}}
\def\sp@translatelet#1#2{\translatelet{#1}{sp@translations@#2}}
\def\sp@settranslation#1#2#3{\providetranslation[to=#1]{sp@translations@#2}{#3}}

% fields of the titlepage
\sp@settranslation{German}{Author}{Autor}\sp@settranslation{English}{Author}{Author}
\sp@settranslation{German}{Examiner}{Gutachter}\sp@settranslation{English}{Examiner}{Examiner}
\sp@settranslation{German}{Supervisor}{Betreuer}\sp@settranslation{English}{Supervisor}{Supervisor}
\sp@settranslation{German}{Co-Supervisor}{Zweitbetreuer}\sp@settranslation{English}{Co-Supervisor}{Co-Supervisor}
\sp@settranslation{German}{Student-Number}{Matrikelnr.}\sp@settranslation{English}{Student-Number}{Student no.}

% NOTE: in english i do desire the output '1^{st} semester' or '5^{th} semester'
% In gemran i do like '1. Semester', '5. Semester' Therefore, the following consumer will do exactly this
\sp@settranslation{German}{Semester}{Semester}\sp@settranslation{English}{Semester}{semester}
\def\sp@adddot#1{#1.\ }\def\sp@nth#1{\nth{#1}\ }
\sp@settranslation{German}{semester@consumer}{\sp@adddot}\sp@settranslation{English}{semester@consumer}{\sp@nth}

% Defaults used
\sp@settranslation{German}{default@institute}{Institut für Softwaretechnik und Programmiersprachen}
\sp@settranslation{English}{default@institute}{Institute of Software Engineering and Programming Languages}

\sp@settranslation{German}{default@faculty}{Fakultät für Ingenieurwissenschaften, Informatik und Psychologie}
\sp@settranslation{English}{default@faculty}{Faculty of Engineering, Computer Science and Psychology}

\sp@settranslation{German}{default@documentType}{Reflexionsbericht}
\sp@settranslation{English}{default@documentType}{Reflective Report}

\sp@settranslation{German}{default@examName}{Anwendungsprojektes Software Engineering}
\sp@settranslation{English}{default@examName}{Software Project Software Engineering}
% Texts used
\sp@settranslation{German}{document@date}{Fassung}\sp@settranslation{English}{document@date}{Version of}
\sp@settranslation{German}{examName@prefix}{im Rahmen des}\sp@settranslation{English}{examName@prefix}{as part of the}
\sp@settranslation{German}{examNumber@prefix}{Prüfungsnr.}\sp@settranslation{English}{examNumber@prefix}{Exam no.}

\sp@settranslation{German}{and}{und}\sp@settranslation{English}{and}{and}

%%%	Custom Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #1 cs name, #2 default
\def\sp@art@n#1#2{\expandafter\def\csname #1\endcsname##1{\@namedef{@#1}{##1}}\@nameuse{#1}{#2}}
% will create an '\#1Email' command as well
\def\sp@art@e#1#2{\sp@art@n{#1Email}{#2}\sp@art@n{#1}{#2}}
\def\sp@art{\@ifstar\sp@art@e\sp@art@n}

% note: why this? Translations are handled differently. If we would just use \sp@translate in the defaults,
% any macro respecting protection would not expand them!
\sp@translatelet\sp@translated@faculty{default@faculty}
\sp@translatelet\sp@translated@institute{default@institute}
\sp@translatelet\sp@translated@examName{default@examName}
\sp@translatelet\sp@translated@documentType{default@documentType}

% What happens here?
% > Look at the comma separated list on the left. Each element in this
%   list is passed as an argument to '\sp@art'. So:
%   '{subtitle}{}' will be used as '\sp@art{subtitle}{}'
%   '*{coexaminer}{}' will be used as '*{coexaminer}{}'
%   sp@art will behave differently if starred!
%   - without a star:
%     sp@art will create a macro with the same name ('\subtitle')
%     that can be used to set another macro with an latex-default
%     '@' prefix. So calling '\subtitle' will set the macro '\@subtitle'
%     to the passed value. Furthermore, sp@art will call the macro
%     ('\subtitle') with the second argument as default ('')
%   - with a star:
%     sp@art will do the same as sp@art without a star but will call
%     sp@art without a star again to create another macro with the
%     'Email' suffix. Therefore: '*{examiner}{}' is short for:
%     \sp@art{examiner}{} and \sp@art{examinerEmail}{}
\@for\cmd:={%
	% defaults, redefined to allow their empty checks
	{subtitle}{},%
	{faculty}{\sp@translated@faculty},% translations: see above
	{institute}{\sp@translated@institute},%
	{publishingYear}{\the\year},%
	{license}{cc-by},
	% exam
	{examId}{},{examName}{\sp@translated@examName},{term}{},%
	% student
	{email}{},{studentId}{},{major}{},{semester}{},%
	% supervisors
	*{examiner}{},*{coexaminer}{},*{supervisor}{},*{cosupervisor}{},%
	% extras
	{documentType}{\sp@translated@documentType}%
}\do{%
	\expandafter\sp@art\cmd\relax
}

% just to stay clean, we undefine the additional macros again
\let\sp@art@n\undefined
\let\sp@art@e\undefined
\let\sp@art\undefined

% Definition of a switch case statement
\def\sp@ifequal#1#2#3{\ifdefstring{#1}{#2}{\@sp@switch@df@true#3}{}\ignorespaces}
\newif\if@sp@switch@df@
\newenvironment{sp@switch}[1]{\begingroup%
	\def\ifequal{\sp@ifequal{#1}}\def\default##1{\if@sp@switch@df@\else##1\fi\ignorespaces}\ignorespaces}{\relax\endgroup\ignorespacesafterend}
% if #1 is empty, present the error with #2, else do #3
\def\cs@error@on@empty#1(#2)#3{\@ifnextchar[{\cs@error@on@empty@{#1}(#2){#3}}{\cs@error@on@empty@{#1}(#2){#3}[]}}%
\def\cs@error@on@empty@#1(#2)#3[#4]{
\ifdefempty{#1}{%
\ClassError{\sp@class@name}{No #2 defined}{%
Please define the field #2 using '\textbackslash #2{<value>}'.#4}}{#3}}

% Now we can use a switch environment, that supplies us with
% '\ifequal' and '\default' commands... examples can be seen
% below in the class file


%%%%	The Logo of the Uni Ulm	   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% what happens here?
% > In short, i do load the logo of the ulm university and guard it
%   as required by the corporate design (therefore i assure
%   there is the minimum required 'u'-space)
%   U may skip to the definition of '\uulmlogo' etc. to see their usage
\newsavebox\sp@uulm@logo \savebox\sp@uulm@logo{\includegraphics{uulm/media/uulm_logo_2021.pdf}}

% 'u' width is 39.197, total width is 283.901
% therefore the target fraction should be 0.13806573418198598 independent of scale
\newlength\sp@uulm@logo@uwidth
\sp@uulm@logo@uwidth=\dimexpr.138065\wd\sp@uulm@logo\relax
% create a box with the proclaimed protection zone

\newsavebox\sp@uulm@logo@protected
\begingroup\everypar{}\globaldefs=\@ne
\savebox\sp@uulm@logo@protected{\hbox{\hskip\sp@uulm@logo@uwidth\vbox{\vskip\sp@uulm@logo@uwidth\usebox\sp@uulm@logo\vskip\sp@uulm@logo@uwidth}}\hskip\sp@uulm@logo@uwidth}
\endgroup

% #1 allows to manipulate the width according to the styleguide
\newcommand*\uulmlogo[1][73mm]{\resizebox{#1}!{\usebox\sp@uulm@logo}}
\newcommand*\uulmlogoprotected[1][73mm]{\resizebox{\dimexpr#1+2*\sp@uulm@logo@uwidth\relax}!{\usebox\sp@uulm@logo@protected}}

%%%%	The titlepage(s)	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% those lengths may be used to change the appearance of the
% right bar, left to the faculty infomration
\newlength\sp@layout@facultybar@wd \sp@layout@facultybar@wd=3pt
\newlength\sp@layout@facultybar@hpad \sp@layout@facultybar@hpad=\sp@layout@facultybar@wd
\newlength\sp@layout@facultybar@vpad \sp@layout@facultybar@vpad=4pt


% What happens here?
% > I use tikz to place the logos with appropriate paddings.
%   tikz would not be necessary here, yet it made those definitions
%   a lot simpler.
\def\sp@title@logobanner{% Logo definition
\begin{tikzpicture}[inner sep=\z@,outer sep=\z@,align=flush left]
	% TODO: use the komafonts; hinten anstellen
	\node[font=\small,text width=6.75cm] (@fac@logo) at (0,0) {\ifx\@faculty\@empty\else\bfseries\@faculty\smallskip\par\fi\mdseries\@institute};
	% dynamically draw the red bar, but only if there is any text to draw the bar
	\def\draw@redbar{\path[fill,cs-red] (@fac@logo.north west)++(-\sp@layout@facultybar@hpad,\sp@layout@facultybar@vpad)
	rectangle ([shift={(-\sp@layout@facultybar@hpad-\sp@layout@facultybar@wd,-\sp@layout@facultybar@vpad)}]@fac@logo.south west);}
	\ifx\@faculty\@empty\ifx\@institute\@empty\let\draw@redbar\relax\fi\fi
	\draw@redbar
\end{tikzpicture}\null\hfill\uulmlogo\par}
% general preamble for a  title setup
% it should be placed within a group to not take effect for the
% whole document
\def\sp@title@prefix{\hypersetup{allcolors=.}%
\pagestyle{empty}%
\setparsizes\z@\z@{\z@\@plus1fil}\par@updaterelative
}

% This definition typesets the complex (two page) title.
% This behavior can be switched with the 'simple-title' and
% 'complex-title' class options.
\def\sp@complex@title{%
\begingroup
\sp@title@logobanner % place the logos
\sp@title@prefix % generic
% rest of the first page
{	\vspace*{3.333cm}\par % those lengths can be seen as magic numbers
	\centering
	{\huge\@documentType}\par
	\vspace{1cm}
	{\footnotesize\ifdefempty{\@examName}{}{\sp@translate{examName@prefix} \@examName\par}
	\ifdefempty{\@examId}{%
		\ClassError{\sp@class@name}{No examId defined}{
			An examID can either be one of the following parameters:\MessageBreak
			- 'SEB'			for the Software Engineering Bachelor Project\MessageBreak
			- 'SEM/A'		for the Software Engineering Master Project A\MessageBreak
			- 'SEM/B'		for the Software Engineering Master Project B\MessageBreak
			- 'CS/FM'		for free module in Computer Science\MessageBreak
			- 'CS/APSE'		for Project Application of modern principles of software engineering in software development in Computer Science Master\MessageBreak
			- 'CS/IP'		for an individual project in Computer Science Master\MessageBreak
			- 'MI/APSE'		for Project Application of modern principles of software engineering in software development in Media Informatics Master\MessageBreak
			- 'MI/IP'		for an individual project in Media Informatics Master\MessageBreak
			- an other exam Id\MessageBreak
			\MessageBreak
			The field shall not be empty.
		}%
	}{%
	% Example of switch case :D
	\sp@translate{examNumber@prefix}\space\begin{sp@switch}{\@examId}
		\ifequal{SEB}{13369}
		\ifequal{SEM/A}{13369}
		\ifequal{SEM/B}{13369}
		\ifequal{CS/FM}{14669}
		\ifequal{CS/APSE}{14192}
		\ifequal{CS/IP}{14078}
		\ifequal{MI/APSE}{14192}
		\ifequal{MI/IP}{14078}
		\default{\@examId}
	\end{sp@switch}
	}
	}\\[3em]

	\vspace{2cm}
	{\Large \@title}\par% place the title and term texts
	\vspace{1cm}
	{\footnotesize \@term}\par
}
\vfill
%%%% Start of the "below block"
% Columns are achieved by minipages
\begingroup
\begin{minipage}[t]{.48\textwidth}
\begin{flushleft} \large
\textbf{\sp@translate{Author}}\medskip\par
\cs@error@on@empty{\@author}(author){\@author\@par}
{\normalsize
	\cs@error@on@empty{\@email}(email){\href{mailto:\@email}{\@email}\@par}
	\cs@error@on@empty{\@studentId}(studentId){\sp@translate{Student-Number}: \@studentId\@par}
	\cs@error@on@empty{\@major}(major){\@major\@par}[\MessageBreak Please note, that you should also define your degree here.\MessageBreak For example: 'Software Engineering, M.Sc.']
	\cs@error@on@empty{\@semester}(semester){\sp@translate{semester@consumer}{\@semester}\sp@translate{Semester}\@par}[\MessageBreak Please note, that you only need to set a number here.]
}
\end{flushleft}
\end{minipage}\hfill\begin{minipage}[t]{.48\textwidth}
\begin{flushright} \large% We could make block commands here
	% examining board / Prüfungsauschuss
	% - chairman
	% - examiners / Prüfer, Gutachter
	\ifdefempty{\@examiner}{}{%
		\textbf{\sp@translate{Examiner}}\par
		\medskip
		\@examiner\par
		\ifdefempty{\@examinerEmail}{}{%
			{\normalsize \href{mailto:\@examinerEmail}{\@examinerEmail}\par}%
		}%
		\vspace*{1.5em}%
	}%
	\ifdefempty{\@supervisor}{}{%
		\textbf{\sp@translate{Supervisor}}\par
		\medskip
		\@supervisor\par
		\ifdefempty{\@supervisorEmail}{}{%
			{\normalsize \href{mailto:\@supervisorEmail}{\@supervisorEmail}\par}%
		}%
		\vspace*{1.5em}%
	}%
	\ifdefempty{\@cosupervisor}{}{%
		\ifdefempty{\@supervisor}{%
			\ClassWarning{\sp@class@name}{There is no supervisor defined, while a cosupervisor is defined.}
		}{}%
		\textbf{\sp@translate{Co-Supervisor}}\par
		\medskip
		\@cosupervisor\par
		{\normalsize \href{mailto:\@cosupervisorEmail}{\@cosupervisorEmail}\par}%
	}%
\end{flushright}%
\end{minipage}\endgroup
\clearpage
%%%% Second page
% Contains the license information and switches back
% page numbering (as the switch is global in some latex-environments)
{\small\flushleft
\sp@translate{document@date}\space\today\par\vfill
\faCopyright~\@publishingYear~\@author\medskip\par
\sp@typeset@license}
\newpage
\pagenumbering{arabic}
\endgroup}

%% In contrast, the simpletitle :D
\def\sp@simple@title{%
\begingroup
	\sp@title@prefix
	\sp@title@logobanner
	\vspace{2cm}
	\centering
	{\huge\@documentType\bigskip}\par
	{\Large \@title}\par
	{\footnotesize \begin{tabular}[t]{c}\@author\end{tabular}}\vspace{2cm}\par
\endgroup}

% depending on the class-option, this sets 'maketitle' to the appropriate
% title default
\if@sp@simpletitle@
\let\maketitle\sp@simple@title
\else \let\maketitle\sp@complex@title \fi

% This sets the license image
% why at end preamble?
% > This allows the user to change the license via '\license' in the
%   preamble, without generating any overhead on multiple calls.
%   The license image will be requested only once at the end of the
%   preamble
\AtEndPreamble{%
\let\@license@main\@empty
\def\sp@license@cc#1#2{\gdef\@license@main{CC}\gdef\@license@modifier{#1}\gdef\@license@version{#2}}%
\begin{sp@switch}{\@license}
	\ifequal{cc0}{\sp@license@cc{zero}{1.0}}
	\ifequal{cc-by}{\sp@license@cc{by}{4.0}}
	\ifequal{cc-by-sa}{\sp@license@cc{by-sa}{4.0}}
	\ifequal{cc-by-nd}{\sp@license@cc{by-nd}{4.0}}
	\ifequal{cc-by-nc}{\sp@license@cc{by-nc}{4.0}}
	\ifequal{cc-by-nc-sa}{\sp@license@cc{by-nc-sa}{4.0}}
	\ifequal{cc-by-nc-nd}{\sp@license@cc{by-nc-nd}{4.0}}
	\default{%
		\ClassWarning{\sp@class@name}{The license '\@license' was not found. Using value as text.}%
	}
\end{sp@switch}
\ifx\@license@main\@empty
	\let\sp@typeset@license\@license
\else
	\RequirePackage[type={\@license@main},modifier={\@license@modifier}, version={\@license@version}]{doclicense}
	\let\sp@typeset@license\doclicenseThis
\fi}
% end of the class, we are done :D
\endinput