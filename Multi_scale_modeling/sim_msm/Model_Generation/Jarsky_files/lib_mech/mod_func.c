#include <stdio.h>
#include "hocdec.h"
#define IMPORT extern __declspec(dllimport)
IMPORT int nrnmpi_myid, nrn_nobanner_;

extern void _Gfluct_reg();
extern void _SynExp2NMDA_reg();
extern void _ingauss_reg();
extern void _kadist_reg();
extern void _kaprox_reg();
extern void _kdrca1_reg();
extern void _na3_reg();
extern void _nax_reg();
extern void _vecevent_reg();
extern void _xtra_reg();

void modl_reg(){
	//nrn_mswindll_stdio(stdin, stdout, stderr);
    if (!nrn_nobanner_) if (nrnmpi_myid < 1) {
	fprintf(stderr, "Additional mechanisms from files\n");

fprintf(stderr," Gfluct.mod");
fprintf(stderr," SynExp2NMDA.mod");
fprintf(stderr," ingauss.mod");
fprintf(stderr," kadist.mod");
fprintf(stderr," kaprox.mod");
fprintf(stderr," kdrca1.mod");
fprintf(stderr," na3.mod");
fprintf(stderr," nax.mod");
fprintf(stderr," vecevent.mod");
fprintf(stderr," xtra.mod");
fprintf(stderr, "\n");
    }
_Gfluct_reg();
_SynExp2NMDA_reg();
_ingauss_reg();
_kadist_reg();
_kaprox_reg();
_kdrca1_reg();
_na3_reg();
_nax_reg();
_vecevent_reg();
_xtra_reg();
}
