#include <julius/juliuslib.h>
#include "Interface_stub.h"

Recog*
c_init_julius_int(int argc, char *argv[]);

Recog*
c_init_julius() {
  char* argv[] = {
    "executable-name"
    ,"-C"
    ,"main.jconf"
    ,"-C"
    ,"am-dnn.jconf"
    ,"-dnnconf"
    ,"julius.dnnconf"
    ,"-confnet"
    /* "-C main.jconf -C am-dnn.jconf -dnnconf julius.dnnconf" */
    , NULL
  };
  int argc = sizeof(argv) / sizeof(char*) - 1;
  c_init_julius_int(argc, argv);
}

Recog*
c_init_julius_int(int argc, char *argv[])
{
  /**
   * configuration parameter holder
   *
   */
  Jconf *jconf;

  /**
   * Recognition instance
   *
   */
  Recog *recog;

  int ret;

  /************/
  /* Start up */
  /************/
  /* 1. load configurations from command arguments */
  jconf = j_config_load_args_new(argc, argv);
  /* else, you can load configurations from a jconf file */
  //jconf = j_config_load_file_new(jconf_filename);
  if (jconf == NULL) {		/* error */
    fprintf(stderr, "Try '-setting' for built-in engine configuration.\n");
    return NULL;
  }

  /* 2. create recognition instance according to the jconf */
  /* it loads models, setup final parameters, build lexicon
     and set up work area for recognition */
  recog = j_create_instance_from_jconf(jconf);
  if (recog == NULL) {
    fprintf(stderr, "Error in startup\n");
  }

  return recog;
}

/*   /\*********************\/ */
/*   /\* Register callback *\/ */
/*   /\*********************\/ */
/*   /\* register result callback functions *\/ */
/*   callback_add(recog, CALLBACK_EVENT_SPEECH_READY, status_recready, NULL); */
/*   callback_add(recog, CALLBACK_EVENT_SPEECH_START, status_recstart, NULL); */
/*   callback_add(recog, CALLBACK_RESULT, output_result, NULL); */

/*   /\**************************\/ */
/*   /\* Initialize audio input *\/ */
/*   /\**************************\/ */
/*   /\* initialize audio input device *\/ */
/*   /\* ad-in thread starts at this time for microphone *\/ */
/*   if (j_adin_init(recog) == FALSE) {    /\* error *\/ */
/*     return -1; */
/*   } */

/*   /\* output system information to log *\/ */
/*   j_recog_info(recog); */

/*   /\***********************************\/ */
/*   /\* Open input stream and recognize *\/ */
/*   /\***********************************\/ */

/*   if (jconf->input.speech_input == SP_MFCFILE || jconf->input.speech_input == SP_OUTPROBFILE) { */
/*     /\* MFCC file input *\/ */

/*     while (get_line_from_stdin(speechfilename, MAXPATHLEN, "enter MFCC filename->") != NULL) { */
/*       if (verbose_flag) printf("\ninput MFCC file: %s\n", speechfilename); */
/*       /\* open the input file *\/ */
/*       ret = j_open_stream(recog, speechfilename); */
/*       switch(ret) { */
/*       case 0:			/\* succeeded *\/ */
/*   break; */
/*       case -1:          /\* error *\/ */
/*   /\* go on to the next input *\/ */
/*   continue; */
/*       case -2:			/\* end of recognition *\/ */
/*   return; */
/*       } */
/*       /\* recognition loop *\/ */
/*       ret = j_recognize_stream(recog); */
/*       if (ret == -1) return -1;	/\* error *\/ */
/*       /\* reach here when an input ends *\/ */
/*     } */

/*   } else { */
/*     /\* raw speech input (microphone etc.) *\/ */

/*     switch(j_open_stream(recog, NULL)) { */
/*     case 0:			/\* succeeded *\/ */
/*       break; */
/*     case -1:          /\* error *\/ */
/*       fprintf(stderr, "error in input stream\n"); */
/*       return; */
/*     case -2:			/\* end of recognition process *\/ */
/*       fprintf(stderr, "failed to begin input stream\n"); */
/*       return; */
/*     } */

/*     /\**********************\/ */
/*     /\* Recognization Loop *\/ */
/*     /\**********************\/ */
/*     /\* enter main loop to recognize the input stream *\/ */
/*     /\* finish after whole input has been processed and input reaches end *\/ */
/*     ret = j_recognize_stream(recog); */
/*     if (ret == -1) return -1;	/\* error *\/ */

/*     /\*******\/ */
/*     /\* End *\/ */
/*     /\*******\/ */
/*   } */

/*   /\* calling j_close_stream(recog) at any time will terminate */
/*      recognition and exit j_recognize_stream() *\/ */
/*   j_close_stream(recog); */

/*   j_recog_free(recog); */

/*   /\* exit program *\/ */
/*   return(0); */
/* } */

void
c_get_result_confnet (Recog *recog, HsStablePtr *hsStruct)
{
  CN_CLUSTER *c;
  int i;
  RecogProcess *r;
  boolean multi;

  if (recog->process_list->next != NULL) multi = TRUE;
  else multi = FALSE;

  for(r=recog->process_list;r;r=r->next) {
    if (! r->live) continue;
    if (r->result.confnet == NULL) continue;	/* no confnet obtained */

    int row = 0;
    for(c=r->result.confnet;c; row++, c=c->next) {
      for(i=0;i<c->wordsnum;i++) {
        char* cStar = (c->words[i] == WORD_INVALID) ? "-" : r->lm->winfo->woutput[c->words[i]];
        float val = c->pp[i];
        hsAddConfNetData(hsStruct, row, cStar, val);
      }
    }
  }
}
