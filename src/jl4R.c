#include <stdio.h>
#include <string.h>

//#include <julia.h>
//#include "julia.h"
#include "julia.h"
#include <Rdefines.h>
#include <R_ext/PrtUtil.h>

// It seems that this fails on win32 "fd_set" missing!
// #ifndef Win32
// #include <R_ext/eventloop.h>
// #endif



static int jl4R_julia_running=0;
static jl_module_t* jl_R_module;
SEXP jlValue(jl_value_t* jlvalue);

SEXP jl4R_init(SEXP args)
{
  char *julia_home_dir;

  if(!jl4R_julia_running) {
    // if(!isValidString(CADR(args)))
    //  error("invalid argument");
    // julia_home_dir=(char*)CHAR(STRING_ELT(CADR(args), 0));
    // Rprintf("julia_home_dir=%s\n",julia_home_dir);
    // jl_init(julia_home_dir);
    jl_init();
    jl4R_julia_running=1;
    //printf("julia initialized!!!\n");
  }
  return R_NilValue;
}

void jl4R_exit()
{
  if(jl4R_julia_running) {
    jl_atexit_hook(0);
    jl4R_julia_running=0;
    printf("julia finalize!!!\n");
  }
}

SEXP jl4R_running(void) {
  SEXP ans;

  PROTECT(ans=allocVector(LGLSXP,1));
  LOGICAL(ans)[0]=jl4R_julia_running;
  UNPROTECT(1);
  return(ans);
}

SEXP jl_value_type(jl_value_t *res) {
  char *resTy,*aryTy;
  SEXP resR;

  if(res!=NULL) { //=> get a result
    resTy=(char*)jl_typeof_str(res);
    PROTECT(resR=NEW_CHARACTER(1));
    CHARACTER_POINTER(resR)[0]=mkChar(resTy);
    UNPROTECT(1);
    return resR;
  } return R_NilValue;
}

//Maybe try to use cpp stuff to get the output inside julia system (ccall,cgen and cgutils)
//-| TODO: after adding in the jlapi.c jl_is_<C_type> functions replace the strcmp!
SEXP jl_value_to_SEXP(jl_value_t *res) {
  size_t i=0,nd,d;
  SEXP resR;
  SEXP nmsR;
  SEXPTYPE aryTyR;
  jl_value_t *tmp;
  jl_function_t *func;
  char *resTy, *aryTy, *aryTy2;

  if(res!=NULL) { //=> get a result
    resTy=(char*)jl_typeof_str(res);
    //printf("typeof=%s\n",resTy);
    if(strcmp(jl_typeof_str(res),"Int64")==0 || strcmp(jl_typeof_str(res),"Int32")==0)
    //if(jl_is_long(res)) //does not work because of DLLEXPORT
    {
      //printf("elt=%d\n",jl_unbox_long(res));
      PROTECT(resR=NEW_INTEGER(1));
      INTEGER_POINTER(resR)[0]=jl_unbox_long(res);
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(resTy,"Float64")==0)
    //if(jl_is_float64(res))
    {
      PROTECT(resR=NEW_NUMERIC(1));
      NUMERIC_POINTER(resR)[0]=jl_unbox_float64(res);
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(resTy,"Float32")==0)
    //if(jl_is_float64(res))
    {

      PROTECT(resR=NEW_NUMERIC(1));
      NUMERIC_POINTER(resR)[0]=jl_unbox_float32(res);
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(resTy,"Bool")==0)
    //if(jl_is_bool(res))
    {
      PROTECT(resR=NEW_LOGICAL(1));
      LOGICAL(resR)[0]=(jl_unbox_bool(res)  ? TRUE : FALSE);
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(resTy,"DataType")==0)
    //if(jl_is_bool(res))
    {
      PROTECT(resR=NEW_CHARACTER(1));
      CHARACTER_POINTER(resR)[0]=mkChar(jl_typename_str(res));
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(resTy,"Nothing")==0)
    //if(jl_is_bool(res))
    {
      return R_NilValue;
    }
    else
    if(strcmp(resTy,"Complex")==0)
    //if(jl_is_bool(res))
    {

      tmp=(jl_value_t*)jl_get_field(res, "re");
      PROTECT(resR=NEW_COMPLEX(1));
      if(strcmp(jl_typeof_str(tmp),"Float64")==0) {
        COMPLEX(resR)[0].r=jl_unbox_float64(tmp);
        COMPLEX(resR)[0].i=jl_unbox_float64(jl_get_field(res, "im"));
      } else if(strcmp(jl_typeof_str(tmp),"Int64")==0) {
        COMPLEX(resR)[0].r=jl_unbox_long(tmp);
        COMPLEX(resR)[0].i=jl_unbox_long(jl_get_field(res, "im"));
      }
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(resTy,"Regex")==0)
    //if(jl_is_bool(res))
    {
      // call=(jl_function_t*)jl_get_global(jl_base_module, jl_symbol("show"));
      // printf("ici\n");
      // if (call) tmp=jl_call1(call,res);
      // else printf("call failed!\n");
      // printf("ici\n");
      // resR = jl_value_to_VALUE(jl_get_field(res, "pattern"));
      // return resR;
    }
    else
    if(strcmp(resTy,"String")==0)
    {
      PROTECT(resR=NEW_CHARACTER(1));
      CHARACTER_POINTER(resR)[0]=mkChar(jl_string_ptr(res));
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(resTy,"Symbol")==0 )
    {
       PROTECT(resR=NEW_CHARACTER(1));
      CHARACTER_POINTER(resR)[0]=mkChar(jl_symbol_name(res));
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(jl_typeof_str(res),"Tuple")==0)
    //if(jl_is_array(res))
    {
      d=jl_nfields(res); //BEFORE 0.3: d=jl_tuple_len(res);
      PROTECT(resR=allocVector(VECSXP,d));
      for(i=0;i<d;i++) {
        //BEFORE 0.3: SET_ELEMENT(resR,i,jl_value_to_SEXP(jl_tupleref(res,i)));
        SET_ELEMENT(resR,i,jl_value_to_SEXP(jl_fieldref(res,i)));
      }
      UNPROTECT(1);
      return resR;
    }
    else
    if(strcmp(jl_typeof_str(res),"NamedTuple")==0)
    //if(jl_is_array(res))
    {
      d=jl_nfields(res); //BEFORE 0.3: d=jl_tuple_len(res);
      func = jl_get_function(jl_base_module, "keys");
      jl_value_t *keys = jl_call1(func, res);
      PROTECT(nmsR = allocVector(STRSXP, d));
      PROTECT(resR=allocVector(VECSXP,d));
      for(i=0;i<d;i++) {
        //BEFORE 0.3: SET_ELEMENT(resR,i,jl_value_to_SEXP(jl_tupleref(res,i)));
        SET_ELEMENT(resR,i,jl_value_to_SEXP(jl_fieldref(res,i)));
        SET_STRING_ELT(nmsR,i,mkChar(jl_symbol_name(jl_fieldref(keys,i))));
      }
      setAttrib(resR, R_NamesSymbol, nmsR);
      UNPROTECT(1);
      UNPROTECT(1);
      
      return resR;
    }
    else
    if(strcmp(resTy,"Array")==0)
    //if(jl_is_array(res))
    {
      nd = jl_array_rank(res);
      //Rprintf("array_ndims=%d\n",(int)nd);
      aryTy=(char*)jl_typename_str(jl_array_eltype(res));
      aryTy2=(char*)jl_typeof_str(jl_array_eltype(res));
      //Rprintf("type elt=%s,%s\n",aryTy,(char*)jl_typeof_str(jl_array_eltype(res)));
      if(strcmp(aryTy2,"DataType")!=0) return R_NilValue;
      if(strcmp(aryTy,"String")==0) aryTyR=STRSXP;
      else if(strcmp(aryTy,"Int64")==0 || strcmp(aryTy,"Int32")==0) aryTyR=INTSXP;
      else if(strcmp(aryTy,"Bool")==0) aryTyR=LGLSXP;
      else if(strcmp(aryTy,"Complex")==0) aryTyR=CPLXSXP;
      else if(strcmp(aryTy,"Float64")==0 || strcmp(aryTy,"Float32")==0) aryTyR=REALSXP;
      else aryTyR=VECSXP;
      if(nd==1) {//Vector
        d = jl_array_size(res, 0);
        //Rprintf("array_dim[1]=%d\n",(int)d);
        PROTECT(resR=allocVector(aryTyR,d));

        for(i=0;i<d;i++) {
          switch(aryTyR) {
            case STRSXP:
              SET_STRING_ELT(resR,i,mkChar(jl_string_ptr(jl_arrayref((jl_array_t *)res,i))));
              break;
            case INTSXP:
              INTEGER(resR)[i]=jl_unbox_long(jl_arrayref((jl_array_t *)res,i));
              break;
            case LGLSXP:
              LOGICAL(resR)[i]=(jl_unbox_bool(jl_arrayref((jl_array_t *)res,i)) ? TRUE : FALSE);
              break;
            case REALSXP:
              REAL(resR)[i]=jl_unbox_float64(jl_arrayref((jl_array_t *)res,i));
              break;
            case CPLXSXP:
              tmp=(jl_value_t*)jl_get_field(jl_arrayref((jl_array_t *)res,i), "re");
              if(strcmp(jl_typeof_str(tmp),"Float64")==0) {
                COMPLEX(resR)[i].r=jl_unbox_float64(tmp);
                COMPLEX(resR)[i].i=jl_unbox_float64(jl_get_field(jl_arrayref((jl_array_t *)res,i), "im"));
              } else if(strcmp(jl_typeof_str(tmp),"Int64")==0) {
                COMPLEX(resR)[i].r=jl_unbox_long(tmp);
                COMPLEX(resR)[i].i=jl_unbox_long(jl_get_field(jl_arrayref((jl_array_t *)res,i), "im"));
              }
              break;
            case VECSXP:
              SET_ELEMENT(resR,i,jl_value_to_SEXP(jl_arrayref((jl_array_t *)res,i)));
          }
        }
        UNPROTECT(1);
        return resR;
      }
    } else {
      resR = (SEXP)jlValue(res);
      // PROTECT(resR=allocVector(STRSXP,1));
      // PROTECT(nmsR = allocVector(STRSXP, 2));
      // SET_STRING_ELT(resR,0,mkChar(resTy));
      // SET_STRING_ELT(nmsR,0,mkChar(resTy));
      // SET_STRING_ELT(nmsR,1, mkChar("jl_value"));
      // setAttrib(resR, R_ClassSymbol, nmsR);
      // UNPROTECT(1);
      // UNPROTECT(1);
      return resR;
    }
  }
  return R_NilValue;
}

/***************** EVAL **********************/
/*********/

jl_value_t* jl_eval2jl(SEXP args) {
  char *cmdString;
  jl_value_t *res;
  SEXP resR;

  cmdString=(char*)CHAR(STRING_ELT(CADR(args),0));
  res=jl_eval_string(cmdString);
  jl_set_global(jl_main_module, jl_symbol("jl4R_ANSWER"),res);
  return res;
}

SEXP jl4R_eval2R(SEXP args)
{
  jl_value_t *res;
  SEXP resR;
  res = jl_eval2jl(args); 
  resR=jl_value_to_SEXP(res);
  if(res==NULL) {
    if(resR != R_NilValue) resR=R_NilValue;
    else  resR=R_NilValue;//newJLObj(res);
  }
  return resR;
}

SEXP jl4R_run(SEXP args)
{
  char *cmdString;

  cmdString=(char*)CHAR(STRING_ELT(CADR(args),0));
  jl_eval_string(cmdString);
  return R_NilValue;
}


/************ the converse **************/
jl_value_t* Vector_SEXP_to_jl_array(SEXP ans) {
  int n;
  //Rcomplex cpl;
  jl_datatype_t* datatype;
  jl_value_t* array_type;
  jl_array_t* x;
  void* xData;

  n=length(ans);

  switch(TYPEOF(ans)) {
  case REALSXP:
    datatype = jl_float64_type;
    break;
  case INTSXP:
    datatype = jl_int64_type;
    break;
  case LGLSXP:
    datatype = jl_bool_type;
    break;
  }

  array_type = jl_apply_array_type( datatype, 1 );
  x          = jl_alloc_array_1d(array_type , n);
  JL_GC_PUSH1(&x);

  switch(TYPEOF(ans)) {
  case REALSXP:
    xData = (double*)jl_array_data(x);
    for(size_t i=0; i<jl_array_len(x); i++) ((double*)xData)[i] = REAL(ans)[i];
    break;
  case INTSXP:
    xData = (int*)jl_array_data(x);
    for(size_t i=0; i<jl_array_len(x); i++) ((int*)xData)[i] = INTEGER(ans)[i];
    break;
  case LGLSXP:
    xData = (int8_t*)jl_array_data(x);
    for(size_t i=0; i<jl_array_len(x); i++) ((int8_t*)xData)[i] = (INTEGER(ans)[i] ? 1 : 0);
    break;
  case STRSXP:
    // for(i=0;i<n;i++) {
    //   rb_ary_store(res,i,rb_str_new2(CHAR(STRING_ELT(ans,i))));
    // }
    break;
  case CPLXSXP:
    // rb_require("complex");
    // for(i=0;i<n;i++) {
    //   cpl=COMPLEX(ans)[i];
    //   res2 = rb_eval_string("Complex.new(0,0)");
    //   rb_iv_set(res2,"@real",rb_float_new(cpl.r));
    //   rb_iv_set(res2,"@image",rb_float_new(cpl.i));
    //   rb_ary_store(res,i,res2);
    // }
    break;
  }
  JL_GC_POP();

  return (jl_value_t*)x;
}
/****************************/

/********/

SEXP jl4R_get_ans(void) {
  jl_value_t *res;

  res=jl_get_global(jl_main_module, jl_symbol("jl4R_ANSWER"));
  return jl_value_to_SEXP(res);
}

SEXP jl4R_set_global_variable(SEXP args) {
  char *varName;
  jl_value_t *res;

  varName=(char*)CHAR(STRING_ELT(CADR(args),0));
  res=(jl_value_t*)Vector_SEXP_to_jl_array(CADDR(args));
  jl_set_global(jl_main_module, jl_symbol(varName),res);
  //jlapi_print_stdout();
  return R_NilValue;
}


/************************************************/

//// R class jlValue standi g for jl_value_t External Pointer

SEXP jlValue(jl_value_t* jlvalue) {
  SEXP ans,class;
  char *jltype;
  ans=(SEXP)R_MakeExternalPtr((void *)jlvalue, R_NilValue, R_NilValue);
  //if(rbIsRVector(jlobj)) {
    PROTECT(class=allocVector(STRSXP,2));
    jltype=(char*)jl_typeof_str(jlvalue);
    SET_STRING_ELT(class,0, mkChar(jltype));
    SET_STRING_ELT(class,1, mkChar("jlValue"));
  //} else {
  //  PROTECT(class=allocVector(STRSXP,1));
  //  SET_STRING_ELT(class,0, mkChar("jlObj"));
  //}
  //classgets(ans,class);
  SET_CLASS(ans,class);
  UNPROTECT(1);
  return ans;
}

SEXP jl4R_eval2jlValue(SEXP args)
{
  jl_value_t *res;
  res = jl_eval2jl(args);
  return jlValue(res);
}

SEXP jl4R_jlValue_call1(SEXP args) {
  char *meth;
  jl_value_t *jlv, *res;
  jl_function_t *func;
  SEXP resR;

  meth = (char*)CHAR(STRING_ELT(CADR(args),0));
  jlv=(jl_value_t*)R_ExternalPtrAddr(CADDR(args));
  func = jl_get_function(jl_main_module, meth);
  res = jl_call1(func, jlv);
  resR=(SEXP)jlValue(res);
  return resR;
}

SEXP jl4R_jlValue_call2(SEXP args) {
  char *meth;
  jl_value_t *jlv, *res, *jlarg;
  jl_function_t *func;
  SEXP resR;

  meth = (char*)CHAR(STRING_ELT(CADR(args),0));
  jlv=(jl_value_t*)R_ExternalPtrAddr(CADDR(args));
  // printf("meth=%s\n",meth);
  jlarg=(jl_value_t*)R_ExternalPtrAddr(CADDDR(args));
  func = jl_get_function(jl_main_module, meth);
  res = jl_call2(func, jlv,jlarg);
  resR=(SEXP)jlValue(res);
  return resR;
}

SEXP jl4R_jlValue_call3(SEXP args) {
  char *meth;
  jl_value_t *jlv, *res, *jlarg, *jlarg2;
  jl_function_t *func;
  SEXP resR;

  meth = (char*)CHAR(STRING_ELT(CADR(args),0));
  jlv=(jl_value_t*)R_ExternalPtrAddr(CADDR(args));
  jlarg=(jl_value_t*)R_ExternalPtrAddr(CADDDR(args));
  jlarg2=(jl_value_t*)R_ExternalPtrAddr(CAD4R(args));
  func = jl_get_function(jl_main_module, meth);
  res = jl_call3(func, jlv, jlarg, jlarg2);
  resR=(SEXP)jlValue(res);
  return resR;
}

SEXP jl4R_jlValue2R(SEXP args) {
  jl_value_t *jlv, *res;
  SEXP resR;

  jlv=(jl_value_t*)R_ExternalPtrAddr(CADR(args));
  resR = jl_value_to_SEXP(jlv);
  return resR;
}

SEXP jl4R_typeof2R(SEXP args)
{
  jl_value_t *jlv, *res;
  SEXP resR;

  jlv=(jl_value_t*)R_ExternalPtrAddr(CADR(args));
  resR = jl_value_type(jlv);
  return resR;
}




#include <R_ext/Rdynload.h>
static const R_CMethodDef cMethods[] = {
  {NULL,NULL,0}
};

static const R_ExternalMethodDef externalMethods[] = {
  {"jl4R_init",(DL_FUNC) &jl4R_init,-1},
  {"jl4R_exit",(DL_FUNC) &jl4R_exit,-1},
  {"jl4R_eval2R",(DL_FUNC) &jl4R_eval2R,-1},
  {"jl4R_run",(DL_FUNC) &jl4R_run,-1},
  {"jl4R_set_global_variable",(DL_FUNC)&jl4R_set_global_variable,-1},
   // {"jl4R_as_Rvector",(DL_FUNC)&jl4R_as_Rvector,-1},
  // {"jl4R_as_jlRvector",(DL_FUNC)&jl4R_as_jlRvector,-1},
  {"jl4R_eval2jlValue",(DL_FUNC) &jl4R_eval2jlValue,-1},
  {"jl4R_jlValue_call1",(DL_FUNC) &jl4R_jlValue_call1,-1},
  {"jl4R_jlValue_call2",(DL_FUNC) &jl4R_jlValue_call2,-1},
  {"jl4R_jlValue_call3",(DL_FUNC) &jl4R_jlValue_call3,-1},
  {"jl4R_jlValue2R",(DL_FUNC) &jl4R_jlValue2R,-1},
  {"jl4R_typeof2R",(DL_FUNC) &jl4R_typeof2R,-1},
  {NULL,NULL,0}
};

static const R_CallMethodDef callMethods[] = {
  {"jl4R_running",(DL_FUNC) &jl4R_running,0},
  {"jl4R_get_ans",(DL_FUNC) &jl4R_get_ans,0},
  {NULL,NULL,0}
};

void R_init_jl4R(DllInfo *info) {
  R_registerRoutines(info,cMethods,callMethods,NULL,externalMethods);
}

// OLD USELESS STUFF

// SEXP jl4R_as_Rvector(SEXP args)
// {
//   SEXP ans;
//   jl_value_t* jlobj;

//   if (inherits(CADR(args), "jlRvector")) {
//     jlobj=(jl_value_t*) R_ExternalPtrAddr(CADR(args));
//     ans=(SEXP)jl_value_to_SEXP(jlobj);
//     return ans;
//   } else return R_NilValue;
// }

// SEXP jl4R_as_jlRvector(SEXP args)
// {
//   jl_value_t* val;
//   SEXP ans;
//   val=(jl_value_t*)Vector_SEXP_to_jl_array(CADR(args));
//   ans=(SEXP)newJLObj(val);
//   return(ans);
// }

// SEXP newJLRVector(jl_value_t* jlobj) {
//   SEXP ans,class;

//   ans=(SEXP)makeJLObject(jlobj);
//   //if(rbIsRVector(jlobj)) {
//     PROTECT(class=allocVector(STRSXP,2));
//     SET_STRING_ELT(class,0, mkChar("jlRVector"));
//     SET_STRING_ELT(class,1, mkChar("jlObj"));
//   //} else {
//   //  PROTECT(class=allocVector(STRSXP,1));
//   //  SET_STRING_ELT(class,0, mkChar("jlObj"));
//   //}
//   //classgets(ans,class);
//   SET_CLASS(ans,class);
//   UNPROTECT(1);
//   return ans;
// }