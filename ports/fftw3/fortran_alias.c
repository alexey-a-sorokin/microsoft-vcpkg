#if !defined(BENCHFFT_LDOUBLE) && !defined(FFTW_LDOUBLE) && !defined(FFTW_SINGLE) && !defined(BENCHFFT_SINGLE)

#include "fftw3.h"

#undef FFTW_EXTERN
#define FFTW_EXTERN __declspec(dllexport)

FFTW_EXTERN void dfftw_execute_(const fftw_plan* plan) {
    fftw_execute(*plan);
}

FFTW_EXTERN void dfftw_destroy_plan_(fftw_plan* plan) {
    fftw_destroy_plan(*plan);
}

FFTW_EXTERN void dfftw_plan_dft_r2c_1d_(fftw_plan* plan, int* n, double *in, fftw_complex *out, unsigned* flags) {
    *plan = fftw_plan_dft_r2c_1d(*n, in, out, *flags);
}

FFTW_EXTERN void dfftw_plan_dft_1d_(fftw_plan* plan, int* n, fftw_complex *in, fftw_complex *out, int* sign, unsigned* flags) {
    *plan = fftw_plan_dft_1d(*n, in, out, *sign, *flags);
}

FFTW_EXTERN void dfftw_plan_dft_c2r_1d_(fftw_plan* plan, int* n, fftw_complex *in, double *out, unsigned* flags) {
    *plan = fftw_plan_dft_c2r_1d(*n, in, out, *flags);
}

#endif
