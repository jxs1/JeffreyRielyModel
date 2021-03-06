theory RelationalLemmas
  imports Main Relation Transitive_Closure
begin
  
definition symmetric:: "'a rel \<Rightarrow> bool" where
  "symmetric r \<equiv> \<forall>a b . (a, b) \<in> r \<longleftrightarrow> (b, a) \<in> r"
      
definition symmetriccl:: "'a rel \<Rightarrow> 'a rel" where
  "symmetriccl r \<equiv> {(y, x) . (x, y) \<in> r} \<union> r"
  
lemma symmetric_symmetriccl: "\<forall>r . sym (symmetriccl r)"
  apply(simp add: sym_def symmetriccl_def)
  done
    
lemma symm_imp_symm_trancl: "sym r \<longrightarrow> sym (r\<^sup>+)"
  apply(auto simp add: sym_def)
  apply(erule trancl.induct[where ?P = "\<lambda>a b. (b, a) \<in> r\<^sup>+"])
  apply auto
   apply(meson trancl_into_trancl2)
  done



lemma symm_pc: "sym ((symmetriccl r)\<^sup>+)"
  apply(simp add: sym_def)
  by (meson  symm_imp_symm_trancl sym_def symmetric_symmetriccl)
        
lemma rtrancl_eq_Id_trancl: "r\<^sup>* = Id \<union> r\<^sup>+"
  by (simp add: Nitpick.rtrancl_unfold Un_commute)

lemma rtranclp_eq_Id_trancl: "r\<^sup>*\<^sup>* = (\<lambda>x y . ((x, y) \<in> Id) \<or> r\<^sup>+\<^sup>+ x y)"
  by (metis Nitpick.rtranclp_unfold pair_in_Id_conv)

  thm trancl_unfold_right
lemma tranclp_unfold_right: "r\<^sup>+\<^sup>+ = r\<^sup>*\<^sup>* OO r"
sorry

lemma alg_subset: "a \<subseteq> c \<union> b \<Longrightarrow> a - b \<subseteq> c"
  by auto
    
definition build_conflict :: "'a rel \<Rightarrow> 'a rel \<Rightarrow> 'a rel" where
  "build_conflict pc ord \<equiv> symmetriccl {(c,e) . \<forall>d . (c,d) \<in> pc \<and> (d,e) \<in> ord}"
  
end
  