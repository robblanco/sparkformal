(** 
_AUTHOR_

<<
Zhi Zhang
Department of Computer and Information Sciences
Kansas State University
zhangzhi@ksu.edu
>>
*)

Require Export rt_gen.
Require Export rt_opt_impl.

(*
(** * Run-Time Check Subset Specification *)

  Inductive exp_rtc_subset: expRT -> expRT -> Prop :=
    | LiteralRTSubset: forall n l n' l' in_cks ex_cks in_cks' ex_cks',
        subset_of (in_cks ++ ex_cks) (in_cks' ++ ex_cks') = true ->
        exp_rtc_subset (LiteralRT n l in_cks ex_cks) (LiteralRT n' l' in_cks' ex_cks')
    | NameRTSubset: forall n n' nm nm',
        name_rtc_subset nm nm' ->
        exp_rtc_subset (NameRT n nm) (NameRT n' nm')
    | BinExpRTSubset: forall n op e1 e2 in_cks ex_cks n' op' e1' e2' in_cks' ex_cks',
        subset_of (in_cks ++ ex_cks) (in_cks' ++ ex_cks') = true ->
        exp_rtc_subset e1 e1' ->
        exp_rtc_subset e2 e2' ->
        exp_rtc_subset (BinOpRT n op e1 e2 in_cks ex_cks) (BinOpRT n' op' e1' e2' in_cks' ex_cks')
    | UnExpRTSubset: forall n op e in_cks ex_cks n' op' e' in_cks' ex_cks',
        subset_of (in_cks ++ ex_cks) (in_cks' ++ ex_cks') = true ->
        exp_rtc_subset e e' ->
        exp_rtc_subset (UnOpRT n op e in_cks ex_cks) (UnOpRT n' op' e' in_cks' ex_cks')

  with name_rtc_subset: nameRT -> nameRT -> Prop :=
    | IdentifierRTSubset: forall n x ex_cks n' x' ex_cks',
        subset_of ex_cks ex_cks' = true ->
        name_rtc_subset (IdentifierRT n x ex_cks) (IdentifierRT n' x' ex_cks')
    | IndexedComponentRTSubset: forall n x e ex_cks n' x' e' ex_cks',
        subset_of ex_cks ex_cks' = true ->
        name_rtc_subset x x' ->
        exp_rtc_subset e e' ->
        name_rtc_subset (IndexedComponentRT n x e ex_cks) (IndexedComponentRT n' x' e' ex_cks')
    | SelectedComponentRTSubset: forall n x f ex_cks n' x' f' ex_cks',
        subset_of ex_cks ex_cks' = true ->
        name_rtc_subset x x' ->
        name_rtc_subset (SelectedComponentRT n x f ex_cks) (SelectedComponentRT n' x' f' ex_cks').

  Inductive args_rtc_subset: list expRT -> list expRT -> Prop :=
    | ArgsNilSubset:
        args_rtc_subset nil nil
    | ArgsSubset: forall e1 e2 es1 es2,
        exp_rtc_subset e1 e2 ->
        args_rtc_subset es1 es2 ->
        args_rtc_subset (e1 :: es1) (e2 :: es2).

  Inductive stmt_rtc_subset: stmtRT -> stmtRT -> Prop :=
    | NullRTSubset:
        stmt_rtc_subset NullRT NullRT
    | AssignRTSubset: forall n x e n' x' e',
        name_rtc_subset x x' ->
        exp_rtc_subset e e' ->
        stmt_rtc_subset (AssignRT n x e) (AssignRT n' x' e')
    | IfRTSubset: forall n e c1 c2 n' e' c1' c2',
        exp_rtc_subset e e' ->
        stmt_rtc_subset c1 c1' ->
        stmt_rtc_subset c2 c2' ->
        stmt_rtc_subset (IfRT n e c1 c2) (IfRT n' e' c1' c2')
    | WhileRTSubset: forall n e c n' e' c',
        exp_rtc_subset e e' ->
        stmt_rtc_subset c c' ->
        stmt_rtc_subset (WhileRT n e c) (WhileRT n' e' c')
    | CallRTSubset: forall n p_n p args n' p_n' p' args',
        args_rtc_subset args args' ->
        stmt_rtc_subset (CallRT n p_n p args) (CallRT n' p_n' p' args')
    | SeqRTSubset: forall n c1 c2 n' c1' c2',
        stmt_rtc_subset c1 c1' ->
        stmt_rtc_subset c2 c2' ->
        stmt_rtc_subset (SeqRT n c1 c2) (SeqRT n' c1' c2').

  Inductive typeDecl_rtc_subset: typeDeclRT -> typeDeclRT -> Prop :=
    | SubtypeDeclRTSubset: forall n tn t l u n' tn' t' l' u',
        typeDecl_rtc_subset (SubtypeDeclRT n tn t (RangeRT l u)) (SubtypeDeclRT n' tn' t' (RangeRT l' u'))
    | DerivedTypeDeclRTSubset: forall n tn t l u n' tn' t' l' u',
        typeDecl_rtc_subset (DerivedTypeDeclRT n tn t (RangeRT l u)) (DerivedTypeDeclRT n' tn' t' (RangeRT l' u'))
    | IntegerTypeDeclRTSubset: forall n tn l u n' tn' l' u',
        typeDecl_rtc_subset (IntegerTypeDeclRT n tn (RangeRT l u)) (IntegerTypeDeclRT n' tn' (RangeRT l' u')) 
    | ArrayTypeDeclRTSubset: forall n tn tm t n' tn' tm' t',
        typeDecl_rtc_subset (ArrayTypeDeclRT n tn tm t) (ArrayTypeDeclRT n' tn' tm' t')
    | RecordTypeDeclRTSubset: forall n tn fs n' tn' fs',
        typeDecl_rtc_subset (RecordTypeDeclRT n tn fs) (RecordTypeDeclRT n' tn' fs').

  Inductive objDecl_rtc_subset: objDeclRT -> objDeclRT -> Prop :=
    | ObjInitNoneSubset: forall n x t n' x' t',
        objDecl_rtc_subset (mkobjDeclRT n x t None) (mkobjDeclRT n' x' t' None)
    | ObjInitSomeSubset:
        exp_rtc_subset 
        objDecl_rtc_subset (mkobjDeclRT n x t (Some e)) (mkobjDeclRT n' x' t' (Some e'))
*)


(** * Run-Time Check Validator *) 

Section Check_Flags_Validator.
  
  (** To verify run-time check flags generated by the GNAT front end against
      the expected run-time check flags as required by the semantics of SPARK 
      language, any mismatched run-time check flags will be recorded in a message
      of type diff_message identified by a unique ast number ast_number;

      - gnatpro_check_flags: run-time checks of GNAT compiler

      - expected_complete_checks: run-time checks generated by our checks_generator

      - expected_optimized_checks: run-time checks optimized by our checks_optimization

      it should hold that: 
         expected_optimized_checks <= gnatpro_checks <= expected_complete_checks
  *)

  Inductive diff_annotation : Set :=
    not_superset_of_opt_cks :   diff_annotation |
    not_subset_of_cmp_cks :     diff_annotation |
    not_inbetween_opt_cmp_cks : diff_annotation.
  
  Record diff_message: Type := diff {
    ast_number: astnum;
    expected_optimized_checks: check_flags;
    gnatpro_checks: check_flags;
    expected_complete_checks: check_flags;
    anno: diff_annotation
  }.

  (** the return information by the run-time checks verification procedure:
      - OK: run-time check flags generated by GNAT front end match the expected 
            ones as required by the semantics of SPARK language;
      - Mismatch: lists all ast nodes where the run-time check flags are not matching;
      - Error: means two ast trees are not matching, in this case, it is meaningless 
               to compare their check flags;
  *)
  Inductive return_message: Type := 
    | OK: return_message
    | Mismatch: list diff_message -> return_message
    | Error.

  (** compare run-time check flags 'cks2' generated by GNAT front end against the
      expected run-time check flags 'cks1' as required by semantics of SPARK language; 
  *)
  Function check_flags_validator (ast_num: astnum) (opt_cks gnat_cks cmp_cks: check_flags): return_message :=
    if subset_of gnat_cks cmp_cks then
      if subset_of opt_cks gnat_cks then
        OK
      else
        Mismatch ((diff ast_num opt_cks gnat_cks nil not_superset_of_opt_cks) :: nil)
    else
      if subset_of opt_cks gnat_cks then
        Mismatch ((diff ast_num nil gnat_cks cmp_cks not_subset_of_cmp_cks) :: nil)
      else
        Mismatch ((diff ast_num opt_cks gnat_cks cmp_cks not_inbetween_opt_cmp_cks) :: nil).

  (** merge two return message *)
  Function conj_message (m1 m2: return_message): return_message :=
    match m1 with
    | OK => m2
    | Mismatch diff1 =>
        match m2 with
        | OK => m1
        | Mismatch diff2 => Mismatch (diff1 ++ diff2)
        | Error => Error
        end
     | Error => Error
    end.
  
  (** ** Run-Time Check Validator for Expression *)

  Function exp_check_flags_validator (e_opt e_gnat e_cmp: expRT): return_message :=
    match e_opt, e_gnat, e_cmp with
    | LiteralRT n l in_cks ex_cks, LiteralRT n' l' in_cks' ex_cks', LiteralRT n'' l'' in_cks'' ex_cks'' =>
        check_flags_validator n (in_cks ++ ex_cks) (in_cks' ++ ex_cks') (in_cks'' ++ ex_cks'')
    | NameRT n nm, NameRT n' nm', NameRT n'' nm'' =>
        name_check_flags_validator nm nm' nm''
    | BinOpRT n op e1 e2 in_cks ex_cks, BinOpRT n' op' e1' e2' in_cks' ex_cks', 
                                        BinOpRT n'' op'' e1'' e2'' in_cks'' ex_cks'' =>
        conj_message (check_flags_validator n (in_cks ++ ex_cks) (in_cks' ++ ex_cks') (in_cks'' ++ ex_cks''))
                     (conj_message (exp_check_flags_validator e1 e1' e1'')
                                   (exp_check_flags_validator e2 e2' e2''))
     | UnOpRT n op e in_cks ex_cks, UnOpRT n' op' e' in_cks' ex_cks',
                                    UnOpRT n'' op'' e'' in_cks'' ex_cks'' =>
        conj_message (check_flags_validator n (in_cks ++ ex_cks) (in_cks' ++ ex_cks') (in_cks'' ++ ex_cks''))
                     (exp_check_flags_validator e e' e'')
     | _, _, _ => Error
     end

  (** ** Run-Time Check Validator for Name *)

  with name_check_flags_validator (n_opt n_gnat n_cmp: nameRT): return_message :=
    match n_opt, n_gnat, n_cmp with
    | IdentifierRT n x ex_cks, IdentifierRT n' x' ex_cks', IdentifierRT n'' x'' ex_cks'' =>
        check_flags_validator n ex_cks ex_cks' ex_cks''
    | IndexedComponentRT n x e ex_cks, IndexedComponentRT n' x' e' ex_cks', 
                                       IndexedComponentRT n'' x'' e'' ex_cks'' =>
        conj_message (check_flags_validator n ex_cks ex_cks' ex_cks'')
                     (conj_message (name_check_flags_validator x x' x'')
                                   (exp_check_flags_validator e e' e'')
                     )
    | SelectedComponentRT n x f ex_cks, SelectedComponentRT n' x' f' ex_cks',
                                        SelectedComponentRT n'' x'' f'' ex_cks'' =>
        conj_message (check_flags_validator n ex_cks ex_cks' ex_cks'')
                     (name_check_flags_validator x x' x'')
    | _, _, _ => Error
    end.

  Function args_check_flags_validator (es_opt es_gnat es_cmp: list expRT): return_message :=
    match es_opt, es_gnat, es_cmp with
    | nil, nil, nil => OK
    | (e1 :: es_opt'), (e2 :: es_gnat'), (e3 :: es_cmp') =>
        conj_message (exp_check_flags_validator e1 e2 e3)
                     (args_check_flags_validator es_opt' es_gnat' es_cmp')
    | _, _, _ => Error
    end.


  (** ** Run-Time Check Validator for Statement *)

  Function stmt_check_flags_validator (c_opt c_gnat c_cmp: stmtRT): return_message :=
    match c_opt, c_gnat, c_cmp with
    | NullRT, NullRT, NullRT => OK
    | AssignRT n x e, AssignRT n' x' e', AssignRT n'' x'' e'' =>
        conj_message (name_check_flags_validator x x' x'')
                     (exp_check_flags_validator e e' e'')
    | IfRT n e c1 c2, IfRT n' e' c1' c2', IfRT n'' e'' c1'' c2'' =>
        conj_message (exp_check_flags_validator e e' e'')
                     (conj_message (stmt_check_flags_validator c1 c1' c1'')
                                   (stmt_check_flags_validator c2 c2' c2''))
    | WhileRT n e c, WhileRT n' e' c', WhileRT n'' e'' c'' =>
        conj_message (exp_check_flags_validator e e' e'')
                     (stmt_check_flags_validator c c' c'')
    | CallRT n p_n p args, CallRT n' p_n' p' args', CallRT n'' p_n'' p'' args'' =>
        (args_check_flags_validator args args' args'')
    | SeqRT n c1 c2, SeqRT n' c1' c2', SeqRT n'' c1'' c2'' =>
        conj_message (stmt_check_flags_validator c1 c1' c1'')
                     (stmt_check_flags_validator c2 c2' c2'')
    | _, _, _ => Error
    end.

  Function type_decl_check_flags_validator (t_opt t_gnat t_cmp: typeDeclRT): return_message :=
    match t_opt, t_gnat, t_cmp with
    | SubtypeDeclRT n tn t (RangeRT l u), SubtypeDeclRT n' tn' t' (RangeRT l' u'),
      SubtypeDeclRT n'' tn'' t'' (RangeRT l'' u'') =>
        OK
    | DerivedTypeDeclRT n tn t (RangeRT l u), DerivedTypeDeclRT n' tn' t' (RangeRT l' u'),
      DerivedTypeDeclRT n'' tn'' t'' (RangeRT l'' u'') =>
        OK
    | IntegerTypeDeclRT n tn (RangeRT l u), IntegerTypeDeclRT n' tn' (RangeRT l' u'),
      IntegerTypeDeclRT n'' tn'' (RangeRT l'' u'') =>  
        OK
    | ArrayTypeDeclRT n tn tm t, ArrayTypeDeclRT n' tn' tm' t',
      ArrayTypeDeclRT n'' tn'' tm'' t'' =>
        OK
    | RecordTypeDeclRT n tn fs, RecordTypeDeclRT n' tn' fs',
      RecordTypeDeclRT n'' tn'' fs'' =>
        OK
    | _, _, _ => 
        Error
    end.

  Function object_decl_check_flags_validator (o_opt o_gnat o_cmp: objDeclRT): return_message :=
    match o_opt, o_gnat, o_cmp with
    | mkobjDeclRT n x t None, mkobjDeclRT n' x' t' None, 
      mkobjDeclRT n'' x'' t'' None =>
        OK
    | mkobjDeclRT n x t (Some e), mkobjDeclRT n' x' t' (Some e'),
      mkobjDeclRT n'' x'' t'' (Some e'') =>
        exp_check_flags_validator e e' e''
    | _, _, _ => 
        Error
    end.

  Function object_decls_check_flags_validator (os_opt os_gnat os_cmp: list objDeclRT): return_message :=
    match os_opt, os_gnat, os_cmp with
    | nil, nil, nil => OK
    | o1 :: os_opt', o2 :: os_gnat', o3 :: os_cmp' => 
        conj_message (object_decl_check_flags_validator o1 o2 o3)
                     (object_decls_check_flags_validator os_opt' os_gnat' os_cmp')
    | _, _, _ => Error
    end.

  Function param_spec_check_flags_validator (param_opt param_gnat param_cmp: paramSpecRT): return_message :=
    match param_opt, param_gnat, param_cmp with
    | mkparamSpecRT n x m t, mkparamSpecRT n' x' m' t',
      mkparamSpecRT n'' x'' m'' t'' =>
        OK
    end.

  Function param_specs_check_flags_validator (params_opt params_gnat params_cmp: list paramSpecRT): return_message :=
    match params_opt, params_gnat, params_cmp with
    | nil, nil, nil => OK
    | param1 :: params_opt', param2 :: params_gnat', param3 :: params_cmp' => 
        conj_message (param_spec_check_flags_validator param1 param2 param3)
                     (param_specs_check_flags_validator params_opt' params_gnat' params_cmp')
    | _, _, _ => Error
    end.

  (** ** Run-Time Check Validator for Declaration *)

  Function declaration_check_flags_validator (d_opt d_gnat d_cmp: declRT): return_message :=
    match d_opt, d_gnat, d_cmp with
    | NullDeclRT, NullDeclRT, NullDeclRT => OK
    | TypeDeclRT n t, TypeDeclRT n' t', TypeDeclRT n'' t'' => 
        type_decl_check_flags_validator t t' t''
    | ObjDeclRT n o, ObjDeclRT n' o', ObjDeclRT n'' o'' =>
        object_decl_check_flags_validator o o' o''
    | ProcBodyDeclRT n p, ProcBodyDeclRT n' p', ProcBodyDeclRT n'' p'' =>
        procedure_body_check_flags_validator p p' p''
    | SeqDeclRT n d1 d2, SeqDeclRT n' d1' d2', SeqDeclRT n'' d1'' d2'' =>
        conj_message (declaration_check_flags_validator d1 d1' d1'')
                     (declaration_check_flags_validator d2 d2' d2'')
    | _, _, _ => Error
    end

  (** ** Run-Time Check Validator for Procedure *)

  with procedure_body_check_flags_validator (p_opt p_gnat p_cmp: procBodyDeclRT): return_message :=
    match p_opt, p_gnat, p_cmp with
    | mkprocBodyDeclRT n p params decls stmt, mkprocBodyDeclRT n' p' params' decls' stmt',
      mkprocBodyDeclRT n'' p'' params'' decls'' stmt'' =>
        conj_message (param_specs_check_flags_validator params params' params'')
                     (conj_message (declaration_check_flags_validator decls decls' decls'')
                                   (stmt_check_flags_validator stmt stmt' stmt''))
    end.

  (** ** Run-Time Check Validator for Program *)

  Function program_check_flags_validator (p_opt p_gnat p_cmp: programRT): return_message :=
    match p_opt, p_gnat, p_cmp with
    | mkprogramRT declsRT main, mkprogramRT declsRT' main', mkprogramRT declsRT'' main'' =>
        declaration_check_flags_validator declsRT declsRT' declsRT''
    end.

  (** compile2_flagged_declaration_f (st: symboltable) (d: declaration): option declRT, 
      compile2_flagged_declaration_f function computes the expected ast with desired checks, which
      is used to compare with the ast with checks generated by gnatpro frontend;
      x: is the expected ast tree, y: is gnatpro generated ast tree;
      this function is used for test demo;
  *)
  Definition checks_validator (opt_ast_option: option declRT) (gnat_ast: declRT) 
                              (cmp_ast_option: option declRT): return_message :=
    match opt_ast_option, cmp_ast_option with
    | Some opt_ast, Some cmp_ast => declaration_check_flags_validator opt_ast gnat_ast cmp_ast
    | _, _ => Error
    end.

  Definition program_checks_validator (opt_program_option: option programRT) (gnat_program: programRT) 
                                      (cmp_program_option: option programRT): return_message :=
    match opt_program_option, cmp_program_option with
    | Some opt_program, Some cmp_program => 
        program_check_flags_validator opt_program gnat_program cmp_program
    | _, _ => Error
    end.

End Check_Flags_Validator.


(** * Map Back to SPARK Source Code *) 

Section Map_To_Source_Location.

  Record diff_message': Type := diff' {
    astNumber: astnum;
    sourceLoc: source_location;
    expectedOptimizedChecks: check_flags;
    gnatproChecks : check_flags;
    expectedCompleteChecks: check_flags;
    annotation: diff_annotation
  }.

  Inductive return_message': Type := 
    | OK'    : return_message'
    | Error' : return_message'
    | Mismatch': list diff_message' -> return_message'.

  Function wrap_messages_with_source_location (st: symTab) (msgs: list diff_message): option (list diff_message') :=
    match msgs with
    | nil => Some nil
    | (diff n opt_cks gnat_cks cmp_cks a) :: msgs' =>
        match fetch_sloc n st with
        | Some srcLocation =>
            match (wrap_messages_with_source_location st msgs') with
            | Some msgs'' => Some ((diff' n srcLocation opt_cks gnat_cks cmp_cks a) :: msgs'')
            | None        => None
            end
        | None => None
        end
    end.

  Definition map_to_source_location (st: symTab) (bugInfor: return_message): return_message' :=
    match bugInfor with
    | OK    => OK'
    | Error => Error'
    | Mismatch msgs =>
        match (wrap_messages_with_source_location st msgs) with
        | Some msgs' => Mismatch' msgs'
        | None       => Error'
        end
    end.

End Map_To_Source_Location.

(** * help function *)

Function optOProgramImpl (st: symTabRT) (f: option programRT): option programRT := 
  match f with
  | Some p => optProgramImpl st p
  | None => None
  end.

