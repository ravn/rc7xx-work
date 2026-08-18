/* Dhrystone 2.1 -- ported to the K&R/C89 common subset so it compiles UNCHANGED
 * on DR C 1.11, Aztec C86 3.40a/4.2 and Open Watcom (all CP/M-86).
 *
 * Faithful to Weicker/Richardson Dhrystone 2.1 semantics; only the surface
 * syntax is reduced to the intersection all four accept:
 *   - no `enum`            -> Enumeration is `int` with #define constants
 *     (DR C 1.11 has no enum)
 *   - no prototypes / ANSI param lists -> old-style K&R function definitions
 *   - `Boolean` = int; `char` used as-is (DR C char is unsigned, harmless here)
 *   - self-contained: Proc/Func procedures + a minimal driver.
 *
 * Only the Dhrystone PROCEDURES are the object of the code-size measurement; the
 * timing driver is not part of the compared kernel.
 */

/* MAME runtime timing only: guarded so `make compare` (which compiles this
 * kernel for its code-size metric, with MAME_BRACKET unset) is byte-identical.
 * When set, main() loops the measurement body REPS times inside OUT 0x2FE
 * markers -- see src/mame_bracket.h. */
#ifdef MAME_BRACKET
#include "mame_bracket.h"
#ifndef REPS
#define REPS 1
#endif
#endif

#define Ident_1 0
#define Ident_2 1
#define Ident_3 2
#define Ident_4 3
#define Ident_5 4

#define Boolean int
#define Enumeration int
#define One_Fifty  int
#define Thirty     int
#define Capital_Letter char
#define Str_30 char

#define true  1
#define false 0
#define NULL  0

typedef int Arr_1_Dim[50];
typedef int Arr_2_Dim[50][50];

struct record {
    struct record   *Ptr_Comp;
    Enumeration      Discr;
    Enumeration      Enum_Comp;
    int              Int_Comp;
    char             Str_Comp[31];
};
typedef struct record  Rec_Type;
typedef struct record *Rec_Pointer;

Rec_Pointer     Ptr_Glob, Next_Ptr_Glob;
int             Int_Glob;
Boolean         Bool_Glob;
char            Ch_1_Glob, Ch_2_Glob;
int             Arr_1_Glob[50];
int             Arr_2_Glob[50][50];

/* --- string helpers (avoid libc dependence for a pure code-size kernel) --- */
sc_strcpy(d, s)
char *d, *s;
{
    while ((*d++ = *s++) != '\0') ;
}

int sc_strcmp(s1, s2)
char *s1, *s2;
{
    while (*s1 == *s2 && *s1 != '\0') { s1++; s2++; }
    return (*s1 - *s2);
}

/* Whole-record copy. DR C 1.11 cannot assign a struct through a pointer
 * (Error 66 "Unknown pointer size"), exactly the case the standard Dhrystone
 * guards with its `structassign` macro -- so copy field by field. All four
 * compilers use this same helper, keeping the comparison apples-to-apples. */
rec_copy(d, s)
Rec_Pointer d, s;
{
    d->Ptr_Comp  = s->Ptr_Comp;
    d->Discr     = s->Discr;
    d->Enum_Comp = s->Enum_Comp;
    d->Int_Comp  = s->Int_Comp;
    sc_strcpy(d->Str_Comp, s->Str_Comp);
}

/* --- Func_3 --- */
Boolean Func_3(Enum_Par_Val)
Enumeration Enum_Par_Val;
{
    Enumeration Enum_Loc;
    Enum_Loc = Enum_Par_Val;
    if (Enum_Loc == Ident_3) return true;
    return false;
}

/* --- Func_2 --- */
Boolean Func_2(Str_1_Par_Ref, Str_2_Par_Ref)
char *Str_1_Par_Ref, *Str_2_Par_Ref;
{
    One_Fifty Int_Loc;
    Capital_Letter Ch_Loc;
    Int_Loc = 2;
    while (Int_Loc <= 2) {
        if (Func_1(Str_1_Par_Ref[Int_Loc], Str_2_Par_Ref[Int_Loc + 1]) == Ident_1) {
            Ch_Loc = 'A';
            Int_Loc += 1;
        }
    }
    if (Ch_Loc >= 'W' && Ch_Loc < 'Z') Int_Loc = 7;
    if (Ch_Loc == 'R') return true;
    if (sc_strcmp(Str_1_Par_Ref, Str_2_Par_Ref) > 0) {
        Int_Loc += 7;
        Int_Glob = Int_Loc;
        return true;
    }
    return false;
}

/* --- Func_1 --- */
Enumeration Func_1(Ch_1_Par_Val, Ch_2_Par_Val)
Capital_Letter Ch_1_Par_Val, Ch_2_Par_Val;
{
    Capital_Letter Ch_1_Loc;
    Capital_Letter Ch_2_Loc;
    Ch_1_Loc = Ch_1_Par_Val;
    Ch_2_Loc = Ch_1_Loc;
    if (Ch_2_Loc != Ch_2_Par_Val) return Ident_1;
    return Ident_2;
}

/* --- Proc_7 --- */
Proc_7(Int_1_Par_Val, Int_2_Par_Val, Int_Par_Ref)
One_Fifty Int_1_Par_Val, Int_2_Par_Val;
One_Fifty *Int_Par_Ref;
{
    One_Fifty Int_Loc;
    Int_Loc = Int_1_Par_Val + 2;
    *Int_Par_Ref = Int_2_Par_Val + Int_Loc;
}

/* --- Proc_8 --- */
Proc_8(Arr_1_Par_Ref, Arr_2_Par_Ref, Int_1_Par_Val, Int_2_Par_Val)
int Arr_1_Par_Ref[];
int Arr_2_Par_Ref[50][50];
int Int_1_Par_Val, Int_2_Par_Val;
{
    One_Fifty Int_Index;
    One_Fifty Int_Loc;
    Int_Loc = Int_1_Par_Val + 5;
    Arr_1_Par_Ref[Int_Loc] = Int_2_Par_Val;
    Arr_1_Par_Ref[Int_Loc + 1] = Arr_1_Par_Ref[Int_Loc];
    Arr_1_Par_Ref[Int_Loc + 30] = Int_Loc;
    for (Int_Index = Int_Loc; Int_Index <= Int_Loc + 1; Int_Index++)
        Arr_2_Par_Ref[Int_Loc][Int_Index] = Int_Loc;
    Arr_2_Par_Ref[Int_Loc][Int_Loc - 1] += 1;
    Arr_2_Par_Ref[Int_Loc + 20][Int_Loc] = Arr_1_Par_Ref[Int_Loc];
    Int_Glob = 5;
}

/* --- Proc_6 --- */
Proc_6(Enum_Val_Par, Enum_Ref_Par)
Enumeration Enum_Val_Par;
Enumeration *Enum_Ref_Par;
{
    *Enum_Ref_Par = Enum_Val_Par;
    if (!Func_3(Enum_Val_Par)) *Enum_Ref_Par = Ident_4;
    switch (Enum_Val_Par) {
        case Ident_1: *Enum_Ref_Par = Ident_1; break;
        case Ident_2: if (Int_Glob > 100) *Enum_Ref_Par = Ident_1;
                      else *Enum_Ref_Par = Ident_4; break;
        case Ident_3: *Enum_Ref_Par = Ident_2; break;
        case Ident_4: break;
        case Ident_5: *Enum_Ref_Par = Ident_3; break;
    }
}

/* --- Proc_5 --- */
Proc_5()
{
    Ch_1_Glob = 'A';
    Bool_Glob = false;
}

/* --- Proc_4 --- */
Proc_4()
{
    Boolean Bool_Loc;
    Bool_Loc = Ch_1_Glob == 'A';
    Bool_Glob = Bool_Loc | Bool_Glob;
    Ch_2_Glob = 'B';
}

/* --- Proc_3 --- */
Proc_3(Ptr_Ref_Par)
Rec_Pointer *Ptr_Ref_Par;
{
    if (Ptr_Glob != NULL) *Ptr_Ref_Par = Ptr_Glob->Ptr_Comp;
    Proc_7(10, Int_Glob, &Ptr_Glob->Int_Comp);
}

/* --- Proc_2 --- */
Proc_2(Int_Par_Ref)
One_Fifty *Int_Par_Ref;
{
    One_Fifty Int_Loc;
    Enumeration Enum_Loc;
    Int_Loc = *Int_Par_Ref + 10;
    for (;;) {
        if (Ch_1_Glob == 'A') {
            Int_Loc -= 1;
            *Int_Par_Ref = Int_Loc - Int_Glob;
            Enum_Loc = Ident_1;
        }
        if (Enum_Loc == Ident_1) break;
    }
}

/* --- Proc_1 --- */
Proc_1(Ptr_Val_Par)
Rec_Pointer Ptr_Val_Par;
{
    Rec_Pointer Next_Record;
    Next_Record = Ptr_Val_Par->Ptr_Comp;
    rec_copy(Ptr_Val_Par->Ptr_Comp, Ptr_Glob);
    Ptr_Val_Par->Int_Comp = 5;
    Next_Record->Int_Comp = Ptr_Val_Par->Int_Comp;
    Next_Record->Ptr_Comp = Ptr_Val_Par->Ptr_Comp;
    Proc_3(&Next_Record->Ptr_Comp);
    if (Next_Record->Discr == Ident_1) {
        Next_Record->Int_Comp = 6;
        Proc_6(Ptr_Val_Par->Enum_Comp, &Next_Record->Enum_Comp);
        Next_Record->Ptr_Comp = Ptr_Glob->Ptr_Comp;
        Proc_7(Next_Record->Int_Comp, 10, &Next_Record->Int_Comp);
    } else {
        rec_copy(Ptr_Val_Par, Ptr_Val_Par->Ptr_Comp);
    }
}

/* --- minimal driver (not part of the measured kernel) --- */
int Int_1_Loc, Int_2_Loc, Int_3_Loc;
char Ch_Index;
Enumeration Enum_Loc;
Str_30 Str_1_Loc[31];
Str_30 Str_2_Loc[31];

main()
{
    One_Fifty Int_1, Int_2, Int_3;
    Rec_Type r1, r2;
    Ptr_Glob = &r1;
    Next_Ptr_Glob = &r2;
    Ptr_Glob->Ptr_Comp = Next_Ptr_Glob;
    Ptr_Glob->Discr = Ident_1;
    Ptr_Glob->Enum_Comp = Ident_3;
    Ptr_Glob->Int_Comp = 40;
    sc_strcpy(Ptr_Glob->Str_Comp, "DHRYSTONE PROGRAM, SOME STRING");
    sc_strcpy(Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
    Int_1 = 2; Int_2 = 3;
    sc_strcpy(Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
    Bool_Glob = !Func_2(Str_1_Loc, Str_2_Loc);
#ifdef MAME_BRACKET
    /* Loop the measurement body REPS times, bracketed for MAME timing. The
     * one-time setup above (Ptr_Glob, Str_1_Loc) stays outside; a REPS=10 vs 20
     * differential cancels it and the two markers, leaving one Dhrystone run.
     * Guarded so the code-size kernel (no MAME_BRACKET) is a single pass. */
    {
        int Run_Index;
        MAME_START();
        for (Run_Index = 0; Run_Index < REPS; Run_Index++) {
#endif
    while (Int_1 < Int_2) {
        Int_3 = 5 * Int_1 - Int_2;
        Proc_7(Int_1, Int_2, &Int_3);
        Int_1 += 1;
    }
    Proc_8(Arr_1_Glob, Arr_2_Glob, Int_1, Int_3);
    Proc_1(Ptr_Glob);
    Proc_6(Ident_1, &Enum_Loc);
    Proc_4();
    Proc_5();
#ifdef MAME_BRACKET
            Int_1 = 2;   /* reset the loop-carried inputs for the next run */
        }
        MAME_END();
    }
#endif
    return 0;
}
