#include <stdio.h>
#include <string.h>

//#include <julia.h>
#include "julia.h"
#include "julia-api.h"
#include <Rdefines.h>
#include <R_ext/PrtUtil.h>

#ifndef Win32
#include <R_ext/eventloop.h>
#endif



static int jl4R_julia_running=0;

SEXP jl4R_init(SEXP args)
{
  char *julia_home_dir,*mode;

  if(!jl4R_julia_running) {
    if(!isValidString(CADR(args)))
     error("invalid argument");
    julia_home_dir=(char*)CHAR(STRING_ELT(CADR(args), 0));
    mode=(char*)CHAR(STRING_ELT(CADDR(args), 0));
    Rprintf("julia_home_dir=%s\n",julia_home_dir);
    Rprintf("mode=%s\n",julia_home_dir);
    jlapi_init(julia_home_dir,mode);
    jl4R_julia_running=1;
    //printf("julia initialized!!!\n");
  }
  return R_NilValue;
}

// void jl4R_finalize(void)
// {
//   if(jl4R_julia_running) {
//     julia_finalize();
//     jl4R_julia_running=0;
//     printf("julia finalize!!!\n");
//   }
// }

SEXP jl4R_running(void) {
  SEXP ans;

  PROTECT(ans=allocVector(LGLSXP,1));
  LOGICAL(ans)[0]=jl4R_julia_running;
  UNPROTECT(1);
  return(ans);
}


 


//Maybe try to use cpp stuff to get the output inside julia system (ccall,cgen and cgutils)
//-| TODO: after adding in the jlapi.c jl_is_<C_type> functions replace the strcmp! 
SEXP jl_value_to_SEXP(jl_value_t *res) {
  size_t i=0,k,nd,d;
  SEXP resR;
  SEXPTYPE aryTyR;
  jl_value_t *tmp;
  jl_function_t *call;
  char *resTy,*aryTy;

  if(res!=NULL) { //=> get a result
    resTy=(char*)jl_typeof_str(res);
    //printf("typeof=%s\n",jl_typeof_str(res));
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
    if(strcmp(resTy,"ASCIIString")==0 || strcmp(resTy,"UTF8String")==0)
    {
      PROTECT(resR=NEW_CHARACTER(1));
      CHARACTER_POINTER(resR)[0]=mkChar(jl_bytestring_ptr(res));
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
      //Rprintf("type elt=%s\n",aryTy);
      if(strcmp(aryTy,"ASCIIString")==0 || strcmp(aryTy,"UTF8String")==0) aryTyR=STRSXP;
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
              SET_STRING_ELT(resR,i,mkChar(jl_bytestring_ptr(jl_arrayref((jl_array_t *)res,i))));
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
      //TODO: multidim array ruby equivalent???? Is it necessary 
      
    }
    PROTECT(resR=NEW_CHARACTER(1));
    CHARACTER_POINTER(resR)[0]=mkChar(jl_typeof_str(res));
    // resR=rb_str_new2("__unconverted(");
    // rb_str_cat2(resR, jl_typeof_str(res));
    // rb_str_cat2(resR, ")__\n");
    UNPROTECT(1);
    printf("%s\n",jl_bytestring_ptr(jl_eval_string("\"$(ans)\"")));
    return resR;
  }
  //=> No result (command incomplete or syntax error)
  // jlapi_print_stderr(); //If this happens but this is really not sure!
  // resR=rb_str_new2("__incomplete");
  // if(jl_exception_occurred()!=NULL) {
  //   rb_str_cat2(resR, "(");
  //     rb_str_cat2(resR,jl_typeof_str(jl_exception_occurred()));
  //   jl_value_t* err=jl_get_field(jl_exception_occurred(),"msg");
  //   if(err!=NULL) printf("%s: %s\n",jl_typeof_str(jl_exception_occurred()),jl_bytestring_ptr(err));
  //   jl_exception_clear();
  //   rb_str_cat2(resR, ")");
  // }
  // rb_str_cat2(resR, "__");
  return R_NilValue;//resR;
}

/***************** EVAL **********************/

SEXP jl4R_eval(SEXP args)
{
  char *cmdString;
  jl_value_t *res;
   
  cmdString=(char*)CHAR(STRING_ELT(CADR(args),0));
  res=jl_eval_string(cmdString);
  jl_set_global(jl_base_module, jl_symbol("ans"),res);
  jlapi_print_stdout();
  return jl_value_to_SEXP(res);
}

#include <R_ext/Rdynload.h>
static const R_CMethodDef cMethods[] = {
  {NULL,NULL,0}
};

static const R_ExternalMethodDef externalMethods[] = {
  {"jl4R_init",(DL_FUNC) &jl4R_init,-1},
  {"jl4R_eval",(DL_FUNC) &jl4R_eval,-1},
  {NULL,NULL,0}
};

static const R_CallMethodDef callMethods[] = {
  {"jl4R_running",(DL_FUNC) &jl4R_running,0},
  {NULL,NULL,0}
};

void R_init_jl4R(DllInfo *info) {
  R_registerRoutines(info,cMethods,callMethods,NULL,externalMethods);
}

