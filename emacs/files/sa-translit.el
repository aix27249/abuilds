;Taked form http://jalasthana.de/?p=366
;
;You can choose the sa-translit IM by typing M-x “set-input-method”.
;
;Or after you add this text below in your ~/.emacs
;
;; Bind Input Methods to Custom Keystrokes
;(defun toggle-sa-translit-input-method ()
;"toggle  Sanskrit  input method, HK and ITRANS -> IAST"
;(interactive)
;(set-input-method "sa-translit"))
;(global-set-key (kbd "C-c i") 'toggle-sa-translit-input-method)
;
; you can switch input method to sa-translit by
; pressing C-c i
;
 (quail-define-package
 "sa-translit" "Sanskrit Transliteration" "sa-translit" t
 "Converts Harvard-Kyoto and ITRANS scheme to IAST diacritics.
" nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
("aa" ?ā)
("A" ?ā)
("AA" ?Ā)
("AAA" ?A)
("ii" ?ī)
("I" ?ī)
("II" ?Ī)
("III" ?I)
("uu" ?ū)
("U" ?ū)
("UU" ?Ū)
("UUU" ?U)
(".r" ?ṛ)
("R" ?ṛ)
(".rr" ?ṝ)
("RR" ?Ṛ)
("RRR" ?R)
("RRRR" ?Ṝ)
(".l" ?ḷ)
("L" ?ḷ)
("LL" ?Ḷ)
(".ll" ?ḹ)
("LLLL" ?Ḹ)
("LLL" ?L)
(".m" ?ṃ)
("M" ?ṃ)
("MM" ?Ṃ)
("MMM" ?M)
(".h" ?ḥ)
("H" ?ḥ)
("HH" ?Ḥ)
("HHH" ?H)
(";n" ?ṅ)
(",n" ?ṅ)
("G" ?ṅ)
("GG" ?Ṅ)
("GGG" ?G)
("~n" ?ñ)
("J" ?ñ)
("JJ" ?Ñ)
("JJJ" ?J)
(".t" ?ṭ)
("T" ?ṭ)
("TT" ?Ṭ)
("TTT" ?T)
(".d" ?ḍ)
("D" ?ḍ)
("DD" ?Ḍ)
("DDD" ?D)
(".n" ?ṇ)
("N" ?ṇ)
("NN" ?Ṇ)
("NNN" ?N)
(";s" ?ś)
(",s" ?ś)
("z" ?ś)
("zz" ?ś)
("zzz" ?z)
("Z" ?Ś)
("ZZ" ?Ś)
("ZZZ" ?Z)
(".s" ?ṣ)
("S" ?ṣ)
(".S" ?Ṣ)
("SS" ?Ṣ)
("SSS" ?S)
)