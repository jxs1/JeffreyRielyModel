section {* Model *}
text {* This is an implementation of Alan Jeffrey's Event Structure Memory Model in Isabelle/HOL. *}
  
theory EventStructures
imports Main Relation Transitive_Closure RelationalLemmas EventStructures2
begin
  

(*text{* Primitive conflict has no edges in it which can be inferred by the rule 
@{thm [source] confOverPO_def}. *}
definition minimal :: "'a rel \<Rightarrow> 'a rel \<Rightarrow> bool" where
"minimal po conf \<equiv> 
  (\<forall>w.\<forall>x.\<forall>y.\<forall>z. 
    ((y, z) \<in> conf \<and> 
     (x, y) \<in> po \<and> 
     (x, w) \<in> conf \<and>
     (w, z) \<in> po \<longrightarrow> (y = x) \<and> (w = z)))"
*)

(*
text{* Valid event structures are finite, have valid @{term primitive_order}, and valid 
@{term primitive_conflict} *}
definition isValid :: "'a set \<Rightarrow> 'a rel  \<Rightarrow> 'a rel \<Rightarrow> bool" where
"isValid es po conf \<equiv> (
  finite es \<and>
  isValidPO es po \<and>
  minimal po conf \<and> 
  isConfValid conf
)"


declare isValid_def [simp]

definition isValidES :: "'a event_structure \<Rightarrow> bool" where
-- {* Need symmetric closure of primitive conflict *}
"isValidES es \<equiv> isValid 
  (event_set es)
  ((primitive_order es)\<^sup>* )
  ((symmetriccl (primitive_conflict es))\<^sup>+ - Id)"
*)

(* FIXME 
function justifies_event :: "label set \<Rightarrow> label rel" where
"justifies_event evs \<equiv> 
  { (w, r) . (w \<in> evs) \<and> (r \<in> evs) \<and> (\<exists>l l2 v v2 . ((w = (Label W l v)) \<and> (r = (Label R l2 v2)) \<and> (l = l2) \<and> (v = v2))) } \<union>
  { (i, r) . (i \<in> evs) \<and> (r \<in> evs) \<and> (\<exists>v . (i = (Label I '''' _)) \<and> (r = (Label R _ v)) \<and> (v = 0))}"
*)
fun justifies_event :: "label \<Rightarrow> label \<Rightarrow> bool" where
"justifies_event (Label I '''' v) (Label R l2 v2) = (v2 = 0)"|
"justifies_event (Label W l v) (Label R l2 v2) = ((l = l2) \<and> (v = v2))"|
(*"justifies_event x (Label W l v) = True"|
"justifies_event x (Label I l v) = True"|*)
"justifies_event x y = False"

definition conflict_free :: "'a config \<Rightarrow> 'a rel \<Rightarrow> bool" where
"conflict_free c conf \<equiv> (\<forall>e\<in>c. \<not>(\<exists>f\<in>c. (e, f) \<in> conf))"

(*Helper function to get the type of memory action from an event label*)
fun getMemAction :: "label \<Rightarrow> mem_action" where
"getMemAction (Label x _ _) = x"

(*locale model = labelledES*)
(*  fixes es :: "'a event_structure"*)
(*    assumes validity: "isValidES es"*)
    

context labelledES
  begin     
    (*All read events in a configuration are justified by an event in that configuration*)
    definition justified :: "'a config \<Rightarrow> bool" where
    "justified c \<equiv>
       (\<forall>r\<in> c. (getMemAction (label_function es r) = R) \<longrightarrow> 
        (\<exists>e\<in>c. (justifies_event (label_function es e) (label_function es r))))"
    
    definition is_read :: "'a \<Rightarrow> bool" where
      "is_read x \<equiv> (getMemAction (label_function es x) = R)"

    definition justifies_config :: "'a config \<Rightarrow> 'a config \<Rightarrow> bool"  where
      "justifies_config A B \<equiv> \<forall>x \<in> B. is_read x \<longrightarrow> (\<exists>y \<in> A. justifies_event (label_function es y) (label_function es x))"

    definition justifies_config_subset :: "'a config \<Rightarrow> 'a config \<Rightarrow> bool" (infixl "\<lesssim>" 60) where
      "justifies_config_subset A B  \<equiv> A \<subseteq> B \<and> justifies_config A B"

    definition justifies_config_star ::  "'a config \<Rightarrow> 'a config \<Rightarrow> bool" (infixl "\<lesssim>\<^sup>*" 60) where
        "justifies_config_star a b \<equiv> justifies_config_subset\<^sup>*\<^sup>* a b"

value \<CC>
      
    definition ae_justifies :: "'a config  \<Rightarrow> 'a config \<Rightarrow> bool" where
      "ae_justifies C D \<equiv> \<forall>C' \<in> \<CC>. (C \<lesssim>\<^sup>* C') \<longrightarrow> (\<exists>C'' \<in> \<CC>. (C' \<lesssim>\<^sup>* C'') \<and> justifies_config C'' D)"
      
    definition ae_justifies_subset :: "'a config \<Rightarrow> 'a config \<Rightarrow> bool" (infixl "\<sqsubseteq>" 60) where
      "ae_justifies_subset C D \<equiv> C \<subseteq> D \<and> ae_justifies C D"
    
    definition ae_justifies_subset_star :: "'a config \<Rightarrow> 'a config \<Rightarrow> bool" (infixl "\<sqsubseteq>\<^sup>*" 60) where
      "ae_justifies_subset_star C D \<equiv> ae_justifies_subset\<^sup>*\<^sup>* C D"
    
    definition well_justified :: "'a config  \<Rightarrow> bool" where
      "well_justified C \<equiv> (justified C) \<and> C \<in> \<CC> \<and> {}\<sqsubseteq>\<^sup>*C"
    
    definition initialES :: "nat event_structure" ("\<I>" 1000) where
    "initialES \<equiv> \<lparr> 
      event_set = {},
      primitive_order ={},
      primitive_conflict = {},
      label_function = \<lambda>x.(Label I '''' 0)
    \<rparr>"
    
    definition initialConfig :: "nat set" ("\<C>" 1000) where
      "initialConfig \<equiv> {}"
    
    declare initialConfig_def [simp]
    end

locale config = event_structures +
 

end