; ModuleID = '/Users/ravn/z80/scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/inline-diagnostics/no-inline/rom.ll'
source_filename = "/Users/ravn/z80/scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/rom.c"
target datalayout = "e-m:o-p:16:8-i16:8-i32:8-i64:8-i128:8-f16:8-f32:8-f64:8-f128:8-ve-a:8-n8:16"
target triple = "z80"

%struct.format_entry = type { i8, i8 }
%struct.fdc_command_block = type { i8, i8, i8, i8, i8, i8, i8 }
%struct.fdc_result_block = type { i8, i8, i8, i8, i8, i8, i8, i8 }

@eot_gap3_table = internal unnamed_addr constant [2 x [4 x [2 x %struct.format_entry]]] [[4 x [2 x %struct.format_entry]] [[2 x %struct.format_entry] [%struct.format_entry { i8 26, i8 7 }, %struct.format_entry { i8 52, i8 7 }], [2 x %struct.format_entry] [%struct.format_entry { i8 15, i8 14 }, %struct.format_entry { i8 26, i8 14 }], [2 x %struct.format_entry] [%struct.format_entry { i8 8, i8 27 }, %struct.format_entry { i8 15, i8 27 }], [2 x %struct.format_entry] [%struct.format_entry zeroinitializer, %struct.format_entry { i8 8, i8 53 }]], [4 x [2 x %struct.format_entry]] [[2 x %struct.format_entry] [%struct.format_entry { i8 16, i8 7 }, %struct.format_entry { i8 32, i8 7 }], [2 x %struct.format_entry] [%struct.format_entry { i8 9, i8 14 }, %struct.format_entry { i8 16, i8 14 }], [2 x %struct.format_entry] [%struct.format_entry { i8 5, i8 27 }, %struct.format_entry { i8 9, i8 27 }], [2 x %struct.format_entry] [%struct.format_entry zeroinitializer, %struct.format_entry { i8 5, i8 53 }]]], align 1, !dbg !0
@is_mini = dso_local local_unnamed_addr global i8 0, align 1, !dbg !65
@fdc_cmd = dso_local local_unnamed_addr global %struct.fdc_command_block zeroinitializer, align 1, !dbg !50
@is_mfm = dso_local local_unnamed_addr global i8 0, align 1, !dbg !67
@disk_type = dso_local local_unnamed_addr global i8 0, align 1, !dbg !69
@dma_transfer_size = dso_local local_unnamed_addr global i16 0, align 1, !dbg !77
@fdc_result = dso_local local_unnamed_addr global %struct.fdc_result_block zeroinitializer, align 1, !dbg !30
@error_saved = dso_local local_unnamed_addr global i8 0, align 1, !dbg !81
@floppy_operation_completed_flag = dso_local global i8 0, align 1, !dbg !62
@drive_select = dso_local local_unnamed_addr global i8 0, align 1, !dbg !44
@retry_count = dso_local local_unnamed_addr global i8 0, align 1, !dbg !73
@saved_fdc_command = internal unnamed_addr global i8 0, align 1, !dbg !95
@dma_transfer_address = dso_local local_unnamed_addr global i16 0, align 1, !dbg !75
@fdc_isr_delay = dso_local local_unnamed_addr global i8 0, align 1, !dbg !46
@fdc_result_delay = dso_local local_unnamed_addr global i8 0, align 1, !dbg !48
@more_tracks_to_read = dso_local local_unnamed_addr global i8 0, align 1, !dbg !71
@bytes_left_to_read = dso_local local_unnamed_addr global i16 0, align 1, !dbg !79
@.str = private unnamed_addr constant [20 x i8] c"**DISKETTE ERROR** \00", align 1, !dbg !83
@msg_rc702 = internal constant [7 x i8] c" RC702\00", align 1, !dbg !97
@.str.1 = private unnamed_addr constant [31 x i8] c" **NO DISKETTE NOR LINEPROG** \00", align 1, !dbg !88
@code_end = dso_local local_unnamed_addr constant i8 -1, align 1, !dbg !93
@is_double_sided = internal unnamed_addr global i1 false, align 1, !dbg !149
@sem702_font = internal unnamed_addr constant [1408 x i8] c"\00\00\08\08\00\08\08\08\00\08\08\01@\01@\00\00A\00\01@\00\00A\08\08\01@\08\08\00\1C\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\00\08\08\00\08\08\08\00\08\08\02 \02 \00\00\22\00\02 \00\00\22\08\08\01@\08\08\00\1C\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\14\08\1E\1C\1E>><\22\1C \22\02\22\22>\1E\1C\1E\1C>\22\22\22\22\22><\1C\1C\08\00\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\00\08\08\00\08\08\08\00\08\08\02 \04\10\00\00\1C\00\04\10\00\00\22\08\08\02 \1C\1C6\08\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\14$\22$\02\02\02\22\08 \12\026&\22\22\22\22\22\08\22\22\22\22\22 \0A\22\14\1C\00\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\0Fp\7F\00\00\08\08\00\08\08\08\00\08\08\04\10\18\0C\00\00\00\00\08\08\00\00\14\08\08\02 >>6k\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\22\22$\02$\02\02\02\22\08 \0A\02**\22\22\22\22\02\08\22\22\22\14\14\10\0A2>*\00\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\08\08\00\08\08\08\00\08\08\04\10 \02\00\00\00\00\10\04\00\00\14\08\08\04\10\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\22\22\1C\02$\0E\0E2>\08 \06\02*2\22\1E\22\1E\1C\08\22\14\22\08\08\08\1E*\22\08\00\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7Fx\0Fx\0F\7F\0Fx\7F\7F\08\7F\08\08@\01\01@\00\00`\03\03`\08\04\10\04\10>\7F\7Fk\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F2>$\02$\02\02\22\22\08 \0A\02\22\22\22\02*\0A \08\22\14*\14\08\04\0A&>\08\00\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\08\08\00\00\08\08\08\00\00\08\08\10\04\00\00\02 \00\00\00\00\04\10\14\04\10\08\08\1C\7F>\08\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F.\22$\22$\02\02\22\22\08\22\12\02\22\22\22\02\12\12\22\08\22\086\22\08\02\0A\22\22\08\00\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\00\00\00\00\0F\0F\0F\0Fpppp\7F\7F\7F\7F\08\08\00\00\08\08\08\00\00\08\08\10\04\00\00\04\10\00\00\00\00\08\08\14\02 \08\08\1C*\1C\08\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F \22\1E\1C\1E>\02<\22\1C\1C\22>\22\22>\02,\22\1C\08\1C\08\22\22\08>:\1C\22\08\00pppppppppppppppp\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\08\08\00\00\08\08\08\00\00\08\08 \02\00\00\18\0C\00\1C\00\00\10\04\22\02 \08\08\08\08\08\1C\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\7Fpppppppppppppppp\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\08\08\00\00\08\08\08\00\00\08\08 \02\00\00 \02\00\22\00\00 \02\22\01@\08\08\08\1C\08\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00pppppppppppppppp\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\08\08\00\00\08\08\08\00\00\08\08@\01\00\00@\01\00A\00\00@\01A\01@\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\0F\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00pppppppppppppppp\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F\7F", align 1, !dbg !105
@banner_string = external dso_local local_unnamed_addr constant [0 x i8], align 1
@display_sw1_status.prefix = internal unnamed_addr constant [15 x i8] c"SW1 12345678: \00", align 1, !dbg !150
@qr_screen = internal unnamed_addr constant [117 x i8] c"7s353.xt17s355/%5%%7:%5/%5ss#119%iu#s31}fk&y>te`.pr cpwq\22#w(|=7}$!$).sk=d?,|607s35*a%9uq=b55/%5=.|0\22m7>!###!# #! \22##!", align 1, !dbg !111
@.str.2 = private unnamed_addr constant [7 x i8] c" RC700\00", align 1, !dbg !117
@boot_dir = internal unnamed_addr global ptr null, align 1, !dbg !137
@.str.3 = private unnamed_addr constant [5 x i8] c"SYSM\00", align 1, !dbg !120
@.str.4 = private unnamed_addr constant [5 x i8] c"SYSC\00", align 1, !dbg !125
@.str.5 = private unnamed_addr constant [22 x i8] c" **NO SYSTEM FILES** \00", align 1, !dbg !127
@.str.6 = private unnamed_addr constant [17 x i8] c" **NO KATALOG** \00", align 1, !dbg !132

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none)
define dso_local void @fdc_write_when_ready(i8 noundef zeroext %val) local_unnamed_addr #0 !dbg !171 {
entry:
    #dbg_value(i8 %val, !175, !DIExpression(), !177)
    #dbg_value(i16 0, !176, !DIExpression(), !177)
  br label %do.body, !dbg !178

do.body:                                          ; preds = %do.cond, %entry
  %t.0 = phi i16 [ 0, %entry ], [ %inc, %do.cond ], !dbg !177
    #dbg_value(i16 %t.0, !176, !DIExpression(), !177)
  %0 = load volatile i8, ptr addrspace(2) inttoptr (i16 4 to ptr addrspace(2)), align 4, !dbg !179, !tbaa !186
  %cmp = icmp slt i8 %0, -64, !dbg !187
  br i1 %cmp, label %if.then, label %do.cond, !dbg !188

if.then:                                          ; preds = %do.body
    #dbg_value(i8 %val, !189, !DIExpression(), !194)
  store volatile i8 %val, ptr addrspace(2) inttoptr (i16 5 to ptr addrspace(2)), align 1, !dbg !197, !tbaa !186
  br label %cleanup, !dbg !198

do.cond:                                          ; preds = %do.body
  %inc = add i16 %t.0, 1, !dbg !199
    #dbg_value(i16 %inc, !176, !DIExpression(), !177)
  %tobool.not = icmp eq i16 %inc, 0, !dbg !200
  br i1 %tobool.not, label %cleanup, label %do.body, !dbg !201, !llvm.loop !202

cleanup:                                          ; preds = %do.cond, %if.then
  ret void, !dbg !205
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none)
define dso_local zeroext i8 @fdc_read_when_ready() local_unnamed_addr #0 !dbg !206 {
entry:
    #dbg_value(i16 0, !210, !DIExpression(), !211)
  br label %do.body, !dbg !212

do.body:                                          ; preds = %do.cond, %entry
  %t.0 = phi i16 [ 0, %entry ], [ %inc, %do.cond ], !dbg !211
    #dbg_value(i16 %t.0, !210, !DIExpression(), !211)
  %0 = load volatile i8, ptr addrspace(2) inttoptr (i16 4 to ptr addrspace(2)), align 4, !dbg !213, !tbaa !186
  %cmp = icmp ugt i8 %0, -65, !dbg !217
  br i1 %cmp, label %if.then, label %do.cond, !dbg !218

if.then:                                          ; preds = %do.body
  %1 = load volatile i8, ptr addrspace(2) inttoptr (i16 5 to ptr addrspace(2)), align 1, !dbg !219, !tbaa !186
  br label %cleanup, !dbg !223

do.cond:                                          ; preds = %do.body
  %inc = add i16 %t.0, 1, !dbg !224
    #dbg_value(i16 %inc, !210, !DIExpression(), !211)
  %tobool.not = icmp eq i16 %inc, 0, !dbg !225
  br i1 %tobool.not, label %cleanup, label %do.body, !dbg !226, !llvm.loop !227

cleanup:                                          ; preds = %do.cond, %if.then
  %retval.0 = phi i8 [ %1, %if.then ], [ -1, %do.cond ], !dbg !211
  ret i8 %retval.0, !dbg !229
}

; Function Attrs: minsize nounwind optsize
define dso_local void @delay(i8 noundef zeroext %outer, i8 noundef zeroext %inner) local_unnamed_addr #1 !dbg !230 {
entry:
    #dbg_value(i8 %outer, !234, !DIExpression(), !240)
    #dbg_value(i8 %inner, !235, !DIExpression(), !240)
  %tobool.not = icmp eq i8 %outer, 0, !dbg !241
  br i1 %tobool.not, label %do.end11, label %do.body, !dbg !243

do.body:                                          ; preds = %do.end7, %entry
  %outer.addr.0 = phi i8 [ %dec9, %do.end7 ], [ %outer, %entry ]
    #dbg_value(i8 %outer.addr.0, !234, !DIExpression(), !240)
    #dbg_value(i8 %inner, !236, !DIExpression(), !244)
  br label %do.body1, !dbg !245

do.body1:                                         ; preds = %do.end, %do.body
  %mid.0 = phi i8 [ %inner, %do.body ], [ %dec5, %do.end ], !dbg !244
    #dbg_value(i8 %mid.0, !236, !DIExpression(), !244)
    #dbg_value(i8 0, !238, !DIExpression(), !246)
  br label %do.body2, !dbg !247

do.body2:                                         ; preds = %do.body2, %do.body1
  %k.0 = phi i8 [ 0, %do.body1 ], [ %dec, %do.body2 ], !dbg !246
    #dbg_value(i8 %k.0, !238, !DIExpression(), !246)
  tail call void asm sideeffect "", ""() #13, !dbg !248, !srcloc !250
  %dec = add i8 %k.0, -1, !dbg !251
    #dbg_value(i8 %dec, !238, !DIExpression(), !246)
  %tobool3.not = icmp eq i8 %dec, 0, !dbg !252
  br i1 %tobool3.not, label %do.end, label %do.body2, !dbg !253, !llvm.loop !254

do.end:                                           ; preds = %do.body2
  %dec5 = add i8 %mid.0, -1, !dbg !256
    #dbg_value(i8 %dec5, !236, !DIExpression(), !244)
  %tobool6.not = icmp eq i8 %dec5, 0, !dbg !257
  br i1 %tobool6.not, label %do.end7, label %do.body1, !dbg !258, !llvm.loop !259

do.end7:                                          ; preds = %do.end
  %dec9 = add i8 %outer.addr.0, -1, !dbg !261
    #dbg_value(i8 %dec9, !234, !DIExpression(), !240)
  %tobool10.not = icmp eq i8 %dec9, 0, !dbg !262
  br i1 %tobool10.not, label %do.end11, label %do.body, !dbg !263, !llvm.loop !264

do.end11:                                         ; preds = %do.end7, %entry
  ret void, !dbg !267
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem: none)
define dso_local void @lookup_sectors_and_gap3_for_current_track() local_unnamed_addr #2 !dbg !268 {
entry:
  %0 = load i8, ptr @is_mini, align 1, !dbg !272, !tbaa !186
  %idxprom = zext i8 %0 to i16, !dbg !273
  %arrayidx = getelementptr inbounds nuw [16 x i8], ptr @eot_gap3_table, i16 %idxprom, !dbg !273
  %1 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 3), align 1, !dbg !274, !tbaa !275
  %idxprom1 = zext i8 %1 to i16, !dbg !273
  %arrayidx2 = getelementptr inbounds nuw [4 x i8], ptr %arrayidx, i16 %idxprom1, !dbg !273
  %2 = load i8, ptr @is_mfm, align 1, !dbg !277, !tbaa !186
  %idxprom3 = zext i8 %2 to i16, !dbg !273
  %arrayidx4 = getelementptr inbounds nuw [2 x i8], ptr %arrayidx2, i16 %idxprom3, !dbg !278
    #dbg_value(ptr %arrayidx4, !270, !DIExpression(), !279)
  %3 = load i8, ptr %arrayidx4, align 1, !dbg !280, !tbaa !281
  store i8 %3, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 4), align 1, !dbg !283, !tbaa !284
  %gap3 = getelementptr inbounds nuw i8, ptr %arrayidx4, i16 1, !dbg !285
  %4 = load i8, ptr %gap3, align 1, !dbg !286, !tbaa !287
  store i8 %4, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 5), align 1, !dbg !288, !tbaa !289
  store i8 -128, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 6), align 1, !dbg !290, !tbaa !291
  ret void, !dbg !292
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none, target_mem: none)
define dso_local void @calc_size_of_current_track() local_unnamed_addr #3 !dbg !293 {
entry:
  %0 = load i8, ptr @disk_type, align 1, !dbg !299, !tbaa !186
  %tobool.not = icmp sgt i8 %0, -1, !dbg !300
  br i1 %tobool.not, label %cond.false, label %land.lhs.true, !dbg !301

land.lhs.true:                                    ; preds = %entry
  %1 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !302, !tbaa !303
  %cmp = icmp eq i8 %1, 1, !dbg !304
  br i1 %cmp, label %cond.end, label %cond.false, !dbg !305

cond.false:                                       ; preds = %land.lhs.true, %entry
  %2 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 4), align 1, !dbg !306, !tbaa !284
  %3 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 2), align 1, !dbg !307, !tbaa !308
  %sub = add i8 %2, 1, !dbg !309
  %add = sub i8 %sub, %3, !dbg !310
  %4 = zext i8 %add to i16, !dbg !311
  br label %cond.end, !dbg !312

cond.end:                                         ; preds = %cond.false, %land.lhs.true
  %cond = phi i16 [ %4, %cond.false ], [ 10, %land.lhs.true ], !dbg !313
    #dbg_value(i16 %cond, !295, !DIExpression(), !314)
    #dbg_value(i16 %cond, !296, !DIExpression(), !314)
  %5 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 3), align 1, !dbg !315, !tbaa !275
  %add8 = add i8 %5, 7, !dbg !316
    #dbg_value(i8 %add8, !297, !DIExpression(), !317)
  br label %for.cond, !dbg !318

for.cond:                                         ; preds = %for.body, %cond.end
  %tb.0 = phi i16 [ %cond, %cond.end ], [ %shl, %for.body ], !dbg !314
  %i.0 = phi i8 [ %add8, %cond.end ], [ %dec, %for.body ], !dbg !319
    #dbg_value(i8 %i.0, !297, !DIExpression(), !317)
    #dbg_value(i16 %tb.0, !296, !DIExpression(), !314)
  %cmp11.not = icmp eq i8 %i.0, 0, !dbg !320
  br i1 %cmp11.not, label %for.cond.cleanup, label %for.body, !dbg !322

for.cond.cleanup:                                 ; preds = %for.cond
  store i16 %tb.0, ptr @dma_transfer_size, align 1, !dbg !323, !tbaa !324
  ret void, !dbg !325

for.body:                                         ; preds = %for.cond
  %shl = shl i16 %tb.0, 1, !dbg !326
    #dbg_value(i16 %shl, !296, !DIExpression(), !314)
  %dec = add i8 %i.0, -1, !dbg !328
    #dbg_value(i8 %dec, !297, !DIExpression(), !317)
  br label %for.cond, !dbg !329, !llvm.loop !330
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none)
define dso_local void @fdc_sense_interrupt() local_unnamed_addr #0 !dbg !333 {
entry:
  tail call void @fdc_write_when_ready(i8 noundef zeroext 8) #14, !dbg !334
  %call = tail call zeroext i8 @fdc_read_when_ready() #14, !dbg !335
  store i8 %call, ptr @fdc_result, align 1, !dbg !336, !tbaa !337
  %cmp.not = icmp slt i8 %call, -64, !dbg !339
  br i1 %cmp.not, label %if.end, label %if.then, !dbg !341

if.then:                                          ; preds = %entry
  %call2 = tail call zeroext i8 @fdc_read_when_ready() #14, !dbg !342
  store i8 %call2, ptr getelementptr inbounds nuw (i8, ptr @fdc_result, i16 1), align 1, !dbg !344, !tbaa !345
  br label %if.end, !dbg !346

if.end:                                           ; preds = %if.then, %entry
  ret void, !dbg !347
}

; Function Attrs: minsize nounwind optsize
define dso_local void @fdc_read_result() local_unnamed_addr #1 !dbg !348 {
entry:
    #dbg_value(ptr @fdc_result, !351, !DIExpression(), !352)
    #dbg_value(i8 0, !350, !DIExpression(), !352)
  br label %for.cond, !dbg !353

for.cond:                                         ; preds = %for.body, %entry
  %z80-indexiv.iv = phi i8 [ %3, %for.body ], [ 0, %entry ], !dbg !355
    #dbg_value(i16 poison, !350, !DIExpression(), !352)
  %.not = icmp eq i8 %z80-indexiv.iv, 7, !dbg !356
  br i1 %.not, label %for.end, label %for.body, !dbg !358

for.body:                                         ; preds = %for.cond
  %call = tail call zeroext i8 @fdc_read_when_ready() #14, !dbg !359
  %0 = zext i8 %z80-indexiv.iv to i16, !dbg !361
  %arrayidx = getelementptr inbounds nuw i8, ptr @fdc_result, i16 %0, !dbg !361
  store i8 %call, ptr %arrayidx, align 1, !dbg !362, !tbaa !186
  %1 = load volatile i8, ptr addrspace(2) inttoptr (i16 4 to ptr addrspace(2)), align 4, !dbg !363, !tbaa !186
  %2 = and i8 %1, 16, !dbg !366
  %tobool.not = icmp eq i8 %2, 0, !dbg !367
  %3 = add i8 %z80-indexiv.iv, 1, !dbg !368
    #dbg_value(i16 poison, !350, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !352)
  br i1 %tobool.not, label %if.then, label %for.cond, !dbg !369, !llvm.loop !370

if.then:                                          ; preds = %for.body
  %4 = load volatile i8, ptr addrspace(2) inttoptr (i16 248 to ptr addrspace(2)), align 8, !dbg !373, !tbaa !186
  %arrayidx6 = getelementptr inbounds nuw i8, ptr %arrayidx, i16 1, !dbg !377
  store i8 %4, ptr %arrayidx6, align 1, !dbg !378, !tbaa !186
  br label %cleanup, !dbg !379

for.end:                                          ; preds = %for.cond
  store i8 -2, ptr @error_saved, align 1, !dbg !380, !tbaa !186
  tail call void @error_display_halt(i8 noundef zeroext -2) #14, !dbg !381
  br label %cleanup, !dbg !382

cleanup:                                          ; preds = %for.end, %if.then
  ret void, !dbg !383
}

; Function Attrs: minsize nounwind optsize
define dso_local void @error_display_halt(i8 noundef zeroext %code) local_unnamed_addr #1 !dbg !384 {
entry:
    #dbg_value(i8 %code, !386, !DIExpression(), !387)
  store i8 %code, ptr @error_saved, align 1, !dbg !388, !tbaa !186
  tail call void asm sideeffect "ei", ""() #13, !dbg !389, !srcloc !393
  %0 = load i8, ptr @disk_type, align 1, !dbg !394, !tbaa !186
  %1 = and i8 %0, 1, !dbg !396
  %tobool.not = icmp eq i8 %1, 0, !dbg !397
  br i1 %tobool.not, label %if.end, label %do.end, !dbg !398

if.end:                                           ; preds = %entry
    #dbg_value(i8 0, !399, !DIExpression(), !402)
  store volatile i8 0, ptr addrspace(2) inttoptr (i16 28 to ptr addrspace(2)), align 4, !dbg !404, !tbaa !186
  tail call void @llvm.memcpy.p0.p0.i16(ptr noundef nonnull align 16 dereferenceable(19) inttoptr (i16 30928 to ptr), ptr noundef nonnull align 1 dereferenceable(19) @.str, i16 19, i1 false), !dbg !405
  tail call void @halt_forever() #15, !dbg !407
  unreachable, !dbg !407

do.end:                                           ; preds = %entry
  ret void, !dbg !408
}

; Function Attrs: minsize nounwind optsize
define dso_local zeroext range(i8 0, 2) i8 @wait_fdc_ready(i8 noundef zeroext %timeout) local_unnamed_addr #1 !dbg !409 {
entry:
    #dbg_value(i8 %timeout, !413, !DIExpression(), !414)
  br label %while.cond, !dbg !415

while.cond:                                       ; preds = %while.body, %entry
  %timeout.addr.0 = phi i8 [ %timeout, %entry ], [ %dec, %while.body ]
    #dbg_value(i8 %timeout.addr.0, !413, !DIExpression(), !414)
  %dec = add i8 %timeout.addr.0, -1, !dbg !416
    #dbg_value(i8 %dec, !413, !DIExpression(), !414)
  %tobool.not = icmp eq i8 %dec, 0, !dbg !417
  br i1 %tobool.not, label %return, label %while.body, !dbg !418

while.body:                                       ; preds = %while.cond
  tail call void @delay(i8 noundef zeroext 1, i8 noundef zeroext 2) #14, !dbg !419
  %0 = load volatile i8, ptr @floppy_operation_completed_flag, align 1, !dbg !421, !tbaa !186
  %tobool1.not = icmp eq i8 %0, 0, !dbg !423
  br i1 %tobool1.not, label %while.cond, label %if.then, !dbg !424, !llvm.loop !425

if.then:                                          ; preds = %while.body
  tail call void asm sideeffect "di", ""() #13, !dbg !427, !srcloc !431
  store volatile i8 0, ptr @floppy_operation_completed_flag, align 1, !dbg !432, !tbaa !186
  tail call void asm sideeffect "ei", ""() #13, !dbg !433, !srcloc !393
  br label %return, !dbg !435

return:                                           ; preds = %if.then, %while.cond
  %retval.0 = phi i8 [ 0, %if.then ], [ 1, %while.cond ], !dbg !414
  ret i8 %retval.0, !dbg !436
}

; Function Attrs: minsize nounwind optsize
define dso_local zeroext range(i8 0, 3) i8 @fdc_select_drive_cylinder_head() local_unnamed_addr #1 !dbg !437 {
entry:
  %0 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !438, !tbaa !303
  %shl = shl i8 %0, 2, !dbg !439
  %1 = load i8, ptr @drive_select, align 1, !dbg !440, !tbaa !186
  %or = or i8 %shl, %1, !dbg !441
  %2 = load i8, ptr @fdc_cmd, align 1, !dbg !442, !tbaa !443
    #dbg_value(i8 %or, !444, !DIExpression(), !448)
    #dbg_value(i8 %2, !447, !DIExpression(), !448)
  tail call void @fdc_write_when_ready(i8 noundef zeroext 15) #14, !dbg !450
  %3 = and i8 %or, 7, !dbg !451
  tail call void @fdc_write_when_ready(i8 noundef zeroext %3) #14, !dbg !452
  tail call void @fdc_write_when_ready(i8 noundef zeroext %2) #14, !dbg !453
  %4 = load i8, ptr @fdc_cmd, align 1, !dbg !454, !tbaa !443
  %call = tail call fastcc zeroext i8 @verify_seek_result(i8 noundef zeroext %4) #14, !dbg !455
  ret i8 %call, !dbg !456
}

; Function Attrs: minsize nounwind optsize
define internal fastcc zeroext range(i8 0, 3) i8 @verify_seek_result(i8 noundef zeroext %expected_pcn) unnamed_addr #1 !dbg !457 {
entry:
    #dbg_value(i8 %expected_pcn, !459, !DIExpression(), !460)
  %call = tail call zeroext i8 @wait_fdc_ready(i8 noundef zeroext -1) #14, !dbg !461
  %tobool.not = icmp eq i8 %call, 0, !dbg !463
  br i1 %tobool.not, label %if.end, label %return, !dbg !464

if.end:                                           ; preds = %entry
  %0 = load i8, ptr @drive_select, align 1, !dbg !465, !tbaa !186
  %conv = zext i8 %0 to i16, !dbg !465
  %add = add nuw nsw i16 %conv, 32, !dbg !467
  %1 = load i8, ptr @fdc_result, align 1, !dbg !468, !tbaa !337
  %conv1 = zext i8 %1 to i16, !dbg !469
  %cmp.not = icmp eq i16 %add, %conv1, !dbg !470
  br i1 %cmp.not, label %lor.lhs.false, label %return, !dbg !471

lor.lhs.false:                                    ; preds = %if.end
  %2 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_result, i16 1), align 1, !dbg !472, !tbaa !345
  %cmp5.not = icmp eq i8 %expected_pcn, %2, !dbg !473
  br i1 %cmp5.not, label %if.end8, label %return, !dbg !474

if.end8:                                          ; preds = %lor.lhs.false
  br label %return, !dbg !475

return:                                           ; preds = %if.end8, %lor.lhs.false, %if.end, %entry
  %retval.0 = phi i8 [ 0, %if.end8 ], [ 1, %entry ], [ 2, %lor.lhs.false ], [ 2, %if.end ], !dbg !460
  ret i8 %retval.0, !dbg !476
}

; Function Attrs: minsize nounwind optsize
define dso_local void @fdc_write_full_cmd(i8 noundef zeroext %cmd) local_unnamed_addr #1 !dbg !477 {
entry:
    #dbg_value(i8 %cmd, !479, !DIExpression(), !485)
  %0 = load i8, ptr @is_mfm, align 1, !dbg !486, !tbaa !186
  %tobool.not = icmp eq i8 %0, 0, !dbg !486
  %conv1 = select i1 %tobool.not, i8 0, i8 64, !dbg !487
    #dbg_value(i8 poison, !480, !DIExpression(), !485)
  %1 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !488, !tbaa !303
  %shl = shl i8 %1, 2, !dbg !489
  %2 = load i8, ptr @drive_select, align 1, !dbg !490, !tbaa !186
  %or = or i8 %shl, %2, !dbg !491
    #dbg_value(i8 %or, !481, !DIExpression(), !485)
  tail call void asm sideeffect "di", ""() #13, !dbg !492, !srcloc !431
  %add = add i8 %conv1, %cmd, !dbg !494
  tail call void @fdc_write_when_ready(i8 noundef zeroext %add) #14, !dbg !495
  tail call void @fdc_write_when_ready(i8 noundef zeroext %or) #14, !dbg !496
  %3 = and i8 %cmd, 15, !dbg !497
  %cmp = icmp eq i8 %3, 6, !dbg !498
  br i1 %cmp, label %for.cond, label %if.end, !dbg !499

for.cond:                                         ; preds = %for.body, %entry
  %z80-indexiv.iv = phi i8 [ %6, %for.body ], [ 0, %entry ], !dbg !500
    #dbg_value(i16 poison, !482, !DIExpression(), !502)
  %.not = icmp eq i8 %z80-indexiv.iv, 7, !dbg !503
  br i1 %.not, label %if.end, label %for.body, !dbg !505

for.body:                                         ; preds = %for.cond
  %4 = zext i8 %z80-indexiv.iv to i16, !dbg !506
  %arrayidx = getelementptr inbounds nuw i8, ptr @fdc_cmd, i16 %4, !dbg !506
  %5 = load i8, ptr %arrayidx, align 1, !dbg !506, !tbaa !186
  tail call void @fdc_write_when_ready(i8 noundef zeroext %5) #14, !dbg !508
  %6 = add i8 %z80-indexiv.iv, 1, !dbg !509
    #dbg_value(i16 poison, !482, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !502)
  br label %for.cond, !dbg !510, !llvm.loop !511

if.end:                                           ; preds = %for.cond, %entry
  tail call void asm sideeffect "ei", ""() #13, !dbg !514, !srcloc !393
  ret void, !dbg !516
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem: none)
define dso_local zeroext range(i8 0, 3) i8 @check_fdc_result() local_unnamed_addr #2 !dbg !517 {
entry:
  %0 = load i8, ptr @fdc_result, align 1, !dbg !518, !tbaa !337
  %1 = and i8 %0, -61, !dbg !520
  %2 = load i8, ptr @drive_select, align 1, !dbg !521, !tbaa !186
  %cmp = icmp eq i8 %1, %2, !dbg !522
  br i1 %cmp, label %land.lhs.true, label %if.else, !dbg !523

land.lhs.true:                                    ; preds = %entry
  %3 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_result, i16 1), align 1, !dbg !524, !tbaa !345
  %cmp4 = icmp eq i8 %3, 0, !dbg !525
  br i1 %cmp4, label %land.lhs.true6, label %if.else, !dbg !526

land.lhs.true6:                                   ; preds = %land.lhs.true
  %4 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_result, i16 2), align 1, !dbg !527, !tbaa !528
  %5 = and i8 %4, -65, !dbg !529
  %cmp9 = icmp eq i8 %5, 0, !dbg !530
  br i1 %cmp9, label %return, label %if.else, !dbg !531

if.else:                                          ; preds = %land.lhs.true6, %land.lhs.true, %entry
  %6 = load i8, ptr @retry_count, align 1, !dbg !532, !tbaa !186
  %dec = add i8 %6, -1, !dbg !534
  store i8 %dec, ptr @retry_count, align 1, !dbg !535, !tbaa !186
  %cmp12 = icmp eq i8 %dec, 0, !dbg !536
  %conv14 = select i1 %cmp12, i8 2, i8 1, !dbg !537
  br label %return, !dbg !538

return:                                           ; preds = %if.else, %land.lhs.true6
  %retval.0 = phi i8 [ %conv14, %if.else ], [ 0, %land.lhs.true6 ], !dbg !539
  ret i8 %retval.0, !dbg !540
}

; Function Attrs: minsize nounwind optsize
define dso_local zeroext range(i8 0, 2) i8 @fdc_get_result_bytes(i8 noundef zeroext %cmd, i8 noundef zeroext %retries) local_unnamed_addr #1 !dbg !541 {
entry:
    #dbg_value(i8 %cmd, !545, !DIExpression(), !555)
    #dbg_value(i8 %retries, !546, !DIExpression(), !555)
  store i8 %cmd, ptr @saved_fdc_command, align 1, !dbg !556, !tbaa !186
  store i8 %retries, ptr @retry_count, align 1, !dbg !557, !tbaa !186
  br label %while.cond, !dbg !558

while.cond:                                       ; preds = %if.end12, %entry
  tail call void asm sideeffect "di", ""() #13, !dbg !559, !srcloc !431
  store volatile i8 0, ptr @floppy_operation_completed_flag, align 1, !dbg !561, !tbaa !186
  tail call void asm sideeffect "ei", ""() #13, !dbg !562, !srcloc !393
  %0 = load i8, ptr @saved_fdc_command, align 1, !dbg !564, !tbaa !186
  %1 = and i8 %0, 15, !dbg !565
  %cmp.not = icmp eq i8 %1, 10, !dbg !566
  br i1 %cmp.not, label %if.end, label %if.then, !dbg !567

if.then:                                          ; preds = %while.cond
  tail call void asm sideeffect "di", ""() #13, !dbg !568, !srcloc !431
    #dbg_value(i8 5, !570, !DIExpression(), !573)
  store volatile i8 5, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !575, !tbaa !186
    #dbg_value(i8 69, !576, !DIExpression(), !579)
  store volatile i8 69, ptr addrspace(2) inttoptr (i16 251 to ptr addrspace(2)), align 1, !dbg !581, !tbaa !186
    #dbg_value(i8 0, !582, !DIExpression(), !585)
  store volatile i8 0, ptr addrspace(2) inttoptr (i16 252 to ptr addrspace(2)), align 4, !dbg !587, !tbaa !186
  %2 = load i16, ptr @dma_transfer_address, align 1, !dbg !588, !tbaa !324
    #dbg_value(i16 %2, !548, !DIExpression(), !589)
  %conv2 = trunc i16 %2 to i8, !dbg !590
    #dbg_value(i8 %conv2, !591, !DIExpression(), !594)
  store volatile i8 %conv2, ptr addrspace(2) inttoptr (i16 242 to ptr addrspace(2)), align 2, !dbg !596, !tbaa !186
  %shr = lshr i16 %2, 8, !dbg !590
  %conv3 = trunc nuw i16 %shr to i8, !dbg !590
    #dbg_value(i8 %conv3, !591, !DIExpression(), !597)
  store volatile i8 %conv3, ptr addrspace(2) inttoptr (i16 242 to ptr addrspace(2)), align 2, !dbg !599, !tbaa !186
  %3 = load i16, ptr @dma_transfer_size, align 1, !dbg !600, !tbaa !324
  %sub = add i16 %3, -1, !dbg !601
    #dbg_value(i16 %sub, !553, !DIExpression(), !602)
  %conv6 = trunc i16 %sub to i8, !dbg !603
    #dbg_value(i8 %conv6, !604, !DIExpression(), !607)
  store volatile i8 %conv6, ptr addrspace(2) inttoptr (i16 243 to ptr addrspace(2)), align 1, !dbg !609, !tbaa !186
  %shr7 = lshr i16 %sub, 8, !dbg !603
  %conv8 = trunc nuw i16 %shr7 to i8, !dbg !603
    #dbg_value(i8 %conv8, !604, !DIExpression(), !610)
  store volatile i8 %conv8, ptr addrspace(2) inttoptr (i16 243 to ptr addrspace(2)), align 1, !dbg !612, !tbaa !186
    #dbg_value(i8 1, !570, !DIExpression(), !613)
  store volatile i8 1, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !615, !tbaa !186
  tail call void asm sideeffect "ei", ""() #13, !dbg !616, !srcloc !393
  br label %if.end, !dbg !618

if.end:                                           ; preds = %if.then, %while.cond
  %4 = load i8, ptr @saved_fdc_command, align 1, !dbg !619, !tbaa !186
  tail call void @fdc_write_full_cmd(i8 noundef zeroext %4) #14, !dbg !620
  %call = tail call zeroext i8 @wait_fdc_ready(i8 noundef zeroext -1) #14, !dbg !621
  %tobool.not = icmp eq i8 %call, 0, !dbg !623
  br i1 %tobool.not, label %if.end12, label %cleanup, !dbg !624

if.end12:                                         ; preds = %if.end
  %call13 = tail call zeroext i8 @check_fdc_result() #14, !dbg !625
    #dbg_value(i8 %call13, !547, !DIExpression(), !555)
  switch i8 %call13, label %while.cond [
    i8 0, label %cleanup.loopexit
    i8 2, label %cleanup
  ], !dbg !626

cleanup.loopexit:                                 ; preds = %if.end12
  br label %cleanup, !dbg !628

cleanup:                                          ; preds = %cleanup.loopexit, %if.end12, %if.end
  %retval.0 = phi i8 [ %call13, %cleanup.loopexit ], [ 1, %if.end12 ], [ 1, %if.end ], !dbg !629
  ret i8 %retval.0, !dbg !628
}

; Function Attrs: minsize nounwind optsize
define dso_local zeroext range(i8 0, 2) i8 @fdc_detect_sector_size_and_density() local_unnamed_addr #1 !dbg !630 {
entry:
  br label %while.body, !dbg !631

while.body:                                       ; preds = %if.end7, %entry
  %storemerge = phi i8 [ 0, %entry ], [ 1, %if.end7 ], !dbg !632
  store i8 %storemerge, ptr @is_mfm, align 1, !dbg !632, !tbaa !186
  %call = tail call zeroext i8 @fdc_select_drive_cylinder_head() #14, !dbg !633
  %cmp.not = icmp eq i8 %call, 0, !dbg !636
  br i1 %cmp.not, label %if.end, label %return, !dbg !637

if.end:                                           ; preds = %while.body
  store i16 4, ptr @dma_transfer_size, align 1, !dbg !638, !tbaa !324
  %call2 = tail call zeroext i8 @fdc_get_result_bytes(i8 noundef zeroext 10, i8 noundef zeroext 1) #14, !dbg !639
  %cmp4 = icmp eq i8 %call2, 0, !dbg !641
  br i1 %cmp4, label %while.end, label %if.end7, !dbg !642

if.end7:                                          ; preds = %if.end
  %0 = load i8, ptr @is_mfm, align 1, !dbg !643, !tbaa !186
  %tobool.not = icmp eq i8 %0, 0, !dbg !645
  br i1 %tobool.not, label %while.body, label %return, !dbg !646

while.end:                                        ; preds = %if.end
  %1 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_result, i16 6), align 1, !dbg !647, !tbaa !648
  %2 = and i8 %1, 7, !dbg !649
  store i8 %2, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 3), align 1, !dbg !650, !tbaa !275
  tail call void @lookup_sectors_and_gap3_for_current_track() #14, !dbg !651
  tail call void @calc_size_of_current_track() #14, !dbg !652
  br label %return, !dbg !653

return:                                           ; preds = %while.end, %if.end7, %while.body
  %retval.0 = phi i8 [ 0, %while.end ], [ 1, %while.body ], [ 1, %if.end7 ], !dbg !632
  ret i8 %retval.0, !dbg !654
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @halt_forever() local_unnamed_addr #4 !dbg !655 {
entry:
    #dbg_value(i8 3, !656, !DIExpression(), !659)
  store volatile i8 3, ptr addrspace(2) inttoptr (i16 15 to ptr addrspace(2)), align 1, !dbg !661, !tbaa !186
    #dbg_value(i8 5, !570, !DIExpression(), !662)
  store volatile i8 5, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !664, !tbaa !186
  tail call void asm sideeffect "ei", ""() #13, !dbg !665, !srcloc !393
  br label %for.cond, !dbg !667

for.cond:                                         ; preds = %for.cond, %entry
  br label %for.cond, !dbg !668, !llvm.loop !671
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local zeroext range(i8 0, 2) i8 @compare_6bytes(ptr nofree noundef readonly captures(none) %a, ptr nofree noundef readonly captures(none) %b) local_unnamed_addr #5 !dbg !674 {
entry:
    #dbg_value(ptr %a, !678, !DIExpression(), !681)
    #dbg_value(ptr %b, !679, !DIExpression(), !681)
    #dbg_value(i8 6, !680, !DIExpression(), !681)
  br label %do.body, !dbg !682

do.body:                                          ; preds = %do.cond, %entry
  %a.addr.0 = phi ptr [ %a, %entry ], [ %incdec.ptr, %do.cond ]
  %b.addr.0 = phi ptr [ %b, %entry ], [ %incdec.ptr1, %do.cond ]
  %i.0 = phi i8 [ 6, %entry ], [ %dec, %do.cond ], !dbg !681
    #dbg_value(i8 %i.0, !680, !DIExpression(), !681)
    #dbg_value(ptr %b.addr.0, !679, !DIExpression(), !681)
    #dbg_value(ptr %a.addr.0, !678, !DIExpression(), !681)
    #dbg_value(ptr %a.addr.0, !678, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !681)
  %0 = load i8, ptr %a.addr.0, align 1, !dbg !683, !tbaa !186
    #dbg_value(ptr %b.addr.0, !679, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !681)
  %1 = load i8, ptr %b.addr.0, align 1, !dbg !686, !tbaa !186
  %cmp.not = icmp eq i8 %0, %1, !dbg !687
  br i1 %cmp.not, label %do.cond, label %cleanup, !dbg !688

do.cond:                                          ; preds = %do.body
  %incdec.ptr1 = getelementptr inbounds nuw i8, ptr %b.addr.0, i16 1, !dbg !689
    #dbg_value(ptr %incdec.ptr1, !679, !DIExpression(), !681)
  %incdec.ptr = getelementptr inbounds nuw i8, ptr %a.addr.0, i16 1, !dbg !690
    #dbg_value(ptr %incdec.ptr, !678, !DIExpression(), !681)
  %dec = add nsw i8 %i.0, -1, !dbg !691
    #dbg_value(i8 %dec, !680, !DIExpression(), !681)
  %tobool.not = icmp eq i8 %dec, 0, !dbg !692
  br i1 %tobool.not, label %cleanup, label %do.body, !dbg !693, !llvm.loop !694

cleanup:                                          ; preds = %do.cond, %do.body
  %retval.0 = phi i8 [ 1, %do.body ], [ 0, %do.cond ], !dbg !681
  ret i8 %retval.0, !dbg !696
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(argmem: read)
define dso_local zeroext range(i8 0, 2) i8 @check_sysfile(ptr nofree noundef readonly captures(none) %dir, ptr nofree noundef readonly captures(none) %pattern) local_unnamed_addr #5 !dbg !697 {
entry:
    #dbg_value(ptr %pattern, !703, !DIExpression(), !705)
    #dbg_value(ptr %dir, !702, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !705)
    #dbg_value(i8 4, !704, !DIExpression(), !705)
  br label %do.body, !dbg !706

do.body:                                          ; preds = %do.cond, %entry
  %dir.pn = phi ptr [ %dir, %entry ], [ %dir.addr.0, %do.cond ]
  %pattern.addr.0 = phi ptr [ %pattern, %entry ], [ %incdec.ptr2, %do.cond ]
  %i.0 = phi i8 [ 4, %entry ], [ %dec, %do.cond ], !dbg !705
  %dir.addr.0 = getelementptr inbounds nuw i8, ptr %dir.pn, i16 1, !dbg !705
    #dbg_value(i8 %i.0, !704, !DIExpression(), !705)
    #dbg_value(ptr %pattern.addr.0, !703, !DIExpression(), !705)
    #dbg_value(ptr %dir.addr.0, !702, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !705)
  %0 = load i8, ptr %dir.addr.0, align 1, !dbg !707, !tbaa !186
  %conv = zext i8 %0 to i16, !dbg !707
    #dbg_value(ptr %pattern.addr.0, !703, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !705)
  %1 = load i8, ptr %pattern.addr.0, align 1, !dbg !710, !tbaa !186
  %conv3 = sext i8 %1 to i16, !dbg !710
  %cmp.not = icmp eq i16 %conv, %conv3, !dbg !711
  br i1 %cmp.not, label %do.cond, label %cleanup, !dbg !712

do.cond:                                          ; preds = %do.body
    #dbg_value(ptr %dir.addr.0, !702, !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value), !705)
  %incdec.ptr2 = getelementptr inbounds nuw i8, ptr %pattern.addr.0, i16 1, !dbg !713
    #dbg_value(ptr %incdec.ptr2, !703, !DIExpression(), !705)
  %dec = add nsw i8 %i.0, -1, !dbg !714
    #dbg_value(i8 %dec, !704, !DIExpression(), !705)
  %tobool.not = icmp eq i8 %dec, 0, !dbg !715
  br i1 %tobool.not, label %do.end, label %do.body, !dbg !716, !llvm.loop !717

do.end:                                           ; preds = %do.cond
  %arrayidx = getelementptr i8, ptr %dir, i16 8, !dbg !719
  %2 = load i8, ptr %arrayidx, align 1, !dbg !719, !tbaa !186
  %3 = and i8 %2, 63, !dbg !721
  %cmp6.not = icmp ne i8 %3, 19, !dbg !722
  %. = zext i1 %cmp6.not to i8, !dbg !705
  br label %cleanup, !dbg !705

cleanup:                                          ; preds = %do.end, %do.body
  %retval.0 = phi i8 [ %., %do.end ], [ 1, %do.body ], !dbg !705
  ret i8 %retval.0, !dbg !723
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i16(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i16, i1 immarg) #6

; Function Attrs: minsize nounwind optsize
define dso_local void @prom1_if_present() local_unnamed_addr #1 !dbg !724 {
entry:
  %0 = load volatile i8, ptr addrspace(2) inttoptr (i16 20 to ptr addrspace(2)), align 4, !dbg !725, !tbaa !186
  %1 = and i8 %0, 2, !dbg !729
  %cmp = icmp eq i8 %1, 0, !dbg !730
  br i1 %cmp, label %land.lhs.true, label %do.body, !dbg !731

land.lhs.true:                                    ; preds = %entry
  %call2 = tail call zeroext i8 @compare_6bytes(ptr noundef nonnull inttoptr (i16 8194 to ptr), ptr noundef nonnull @msg_rc702) #14, !dbg !732
  %cmp4 = icmp eq i8 %call2, 0, !dbg !733
  br i1 %cmp4, label %if.then, label %do.body, !dbg !734

if.then:                                          ; preds = %land.lhs.true
  %2 = load i16, ptr inttoptr (i16 8192 to ptr), align 8192, !dbg !735, !tbaa !324
  %3 = inttoptr i16 %2 to ptr, !dbg !737
  tail call void %3() #16, !dbg !737
  ret void, !dbg !738

do.body:                                          ; preds = %land.lhs.true, %entry
  tail call void @llvm.memcpy.p0.p0.i16(ptr noundef nonnull align 16 dereferenceable(30) inttoptr (i16 30928 to ptr), ptr noundef nonnull align 1 dereferenceable(30) @.str.1, i16 30, i1 false), !dbg !739
  tail call void @halt_forever() #15, !dbg !741
  unreachable, !dbg !741
}

; Function Attrs: minsize nounwind optsize
define dso_local void @floppy_legacy_boot() local_unnamed_addr #1 !dbg !742 {
entry:
  %0 = load i8, ptr @is_mini, align 1, !dbg !743, !tbaa !186
  %shl = shl i8 %0, 7, !dbg !744
  %1 = load i8, ptr @disk_type, align 1, !dbg !745, !tbaa !186
  %or = or i8 %shl, %1, !dbg !746
  %dec = add i8 %or, -1, !dbg !747
  store i8 %dec, ptr @disk_type, align 1, !dbg !748, !tbaa !186
  %call = tail call zeroext i8 @fdc_detect_sector_size_and_density() #14, !dbg !749
  store i16 0, ptr @dma_transfer_address, align 1, !dbg !750, !tbaa !324
  tail call fastcc void @fdc_read_data_from_current_location(i16 noundef 24576) #14, !dbg !751
  store i8 1, ptr @disk_type, align 1, !dbg !752, !tbaa !186
  tail call void inttoptr (i16 4096 to ptr)() #16, !dbg !753
  ret void, !dbg !754
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @fdc_read_data_from_current_location(i16 noundef %total_bytes_to_read) unnamed_addr #1 !dbg !755 {
entry:
    #dbg_value(i16 %total_bytes_to_read, !759, !DIExpression(), !766)
  store i16 %total_bytes_to_read, ptr @bytes_left_to_read, align 1, !dbg !767, !tbaa !324
  br label %while.body, !dbg !768

while.body:                                       ; preds = %cleanup, %entry
  %call = tail call zeroext i8 @fdc_select_drive_cylinder_head() #14, !dbg !769
    #dbg_value(i8 %call, !760, !DIExpression(), !770)
  switch i8 %call, label %if.then5 [
    i8 1, label %if.then
    i8 0, label %if.end6
  ], !dbg !771

if.then:                                          ; preds = %while.body
  tail call void @prom1_if_present() #14, !dbg !773
  br label %return, !dbg !775

if.then5:                                         ; preds = %while.body
  tail call void @error_display_halt(i8 noundef zeroext 6) #14, !dbg !776
  br label %return, !dbg !779

if.end6:                                          ; preds = %while.body
  tail call void @calc_size_of_current_track() #14, !dbg !780
  %0 = load i16, ptr @bytes_left_to_read, align 1, !dbg !781, !tbaa !324
  %1 = load i16, ptr @dma_transfer_size, align 1, !dbg !782, !tbaa !324
  %sub = sub nsw i16 %0, %1, !dbg !783
    #dbg_value(i16 %sub, !762, !DIExpression(), !784)
  %cmp7 = icmp sgt i16 %sub, 0, !dbg !785
  br i1 %cmp7, label %if.end10, label %if.else, !dbg !787

if.else:                                          ; preds = %if.end6
  store i16 %0, ptr @dma_transfer_size, align 1, !dbg !788, !tbaa !324
  br label %if.end10

if.end10:                                         ; preds = %if.else, %if.end6
  %.sink = phi i8 [ 0, %if.else ], [ 1, %if.end6 ], !dbg !790
  %storemerge = phi i16 [ 0, %if.else ], [ %sub, %if.end6 ], !dbg !790
  store i8 %.sink, ptr @more_tracks_to_read, align 1, !dbg !790, !tbaa !186
  store i16 %storemerge, ptr @bytes_left_to_read, align 1, !dbg !790, !tbaa !324
  %call11 = tail call zeroext i8 @fdc_get_result_bytes(i8 noundef zeroext 6, i8 noundef zeroext 5) #14, !dbg !791
  %cmp13.not = icmp eq i8 %call11, 0, !dbg !793
  br i1 %cmp13.not, label %if.end16, label %if.then15, !dbg !794

if.then15:                                        ; preds = %if.end10
  tail call void @error_display_halt(i8 noundef zeroext 40) #14, !dbg !795
  br label %return, !dbg !797

if.end16:                                         ; preds = %if.end10
  %2 = load i16, ptr @dma_transfer_size, align 1, !dbg !798, !tbaa !324
  %3 = load i16, ptr @dma_transfer_address, align 1, !dbg !799, !tbaa !324
  %add = add i16 %3, %2, !dbg !800
  store i16 %add, ptr @dma_transfer_address, align 1, !dbg !801, !tbaa !324
  store i16 0, ptr @dma_transfer_size, align 1, !dbg !802, !tbaa !324
  store i8 1, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 2), align 1, !dbg !803, !tbaa !308
  %.b = load i1, ptr @is_double_sided, align 1, !dbg !804
    #dbg_value(i1 %.b, !764, !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value), !805)
  %4 = load i8, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !806, !tbaa !303
  %5 = zext i1 %.b to i8, !dbg !808
  %cmp19 = icmp eq i8 %4, %5, !dbg !808
  br i1 %cmp19, label %if.then21, label %if.else22, !dbg !809

if.then21:                                        ; preds = %if.end16
  %6 = load i8, ptr @fdc_cmd, align 1, !dbg !810, !tbaa !443
  %inc = add i8 %6, 1, !dbg !812
  store i8 %inc, ptr @fdc_cmd, align 1, !dbg !813, !tbaa !443
  br label %cleanup, !dbg !814

if.else22:                                        ; preds = %if.end16
  %inc23 = add i8 %4, 1, !dbg !815
  br label %cleanup

cleanup:                                          ; preds = %if.else22, %if.then21
  %inc23.sink = phi i8 [ 0, %if.then21 ], [ %inc23, %if.else22 ], !dbg !817
  store i8 %inc23.sink, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !817, !tbaa !303
  %7 = load i8, ptr @more_tracks_to_read, align 1, !dbg !818, !tbaa !186
  %tobool.not.not = icmp eq i8 %7, 0, !dbg !820
  br i1 %tobool.not.not, label %return, label %while.body

return:                                           ; preds = %cleanup, %if.then15, %if.then5, %if.then
  ret void, !dbg !821
}

; Function Attrs: minsize nounwind optsize
define dso_local void @syscall(i16 noundef %addr, i16 noundef %de) local_unnamed_addr #1 !dbg !822 {
entry:
    #dbg_value(i16 %addr, !826, !DIExpression(), !830)
    #dbg_value(i16 %de, !827, !DIExpression(), !830)
  %shr = lshr i16 %de, 8, !dbg !831
    #dbg_value(i16 %shr, !828, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value), !830)
    #dbg_value(i16 %de, !829, !DIExpression(), !830)
  store i16 %addr, ptr @dma_transfer_address, align 1, !dbg !832, !tbaa !324
  %0 = trunc i16 %de to i8, !dbg !833
  %conv4 = and i8 %0, 127, !dbg !833
  store i8 %conv4, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 2), align 1, !dbg !834, !tbaa !308
  %and6 = and i16 %shr, 127, !dbg !835
  %conv7 = trunc nuw nsw i16 %and6 to i8, !dbg !836
  store i8 %conv7, ptr @fdc_cmd, align 1, !dbg !837, !tbaa !443
  %cmp = icmp eq i16 %and6, 0, !dbg !838
  br i1 %cmp, label %if.then, label %if.end19.critedge, !dbg !840

if.then:                                          ; preds = %entry
  %call = tail call zeroext i8 @fdc_detect_sector_size_and_density() #14, !dbg !841
  %de.lobit = lshr i16 %de, 15, !dbg !843
  %conv12 = trunc nuw nsw i16 %de.lobit to i8, !dbg !843
  store i8 %conv12, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !844, !tbaa !303
  tail call fastcc void @fdc_read_data_from_current_location(i16 noundef 0) #14, !dbg !845
  store i8 1, ptr @fdc_cmd, align 1, !dbg !846, !tbaa !443
  %call18 = tail call zeroext i8 @fdc_detect_sector_size_and_density() #14, !dbg !849
  br label %if.end19, !dbg !850

if.end19.critedge:                                ; preds = %entry
  %de.lobit.c = lshr i16 %de, 15, !dbg !851
  %conv12.c = trunc nuw nsw i16 %de.lobit.c to i8, !dbg !851
  store i8 %conv12.c, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !852, !tbaa !303
  tail call fastcc void @fdc_read_data_from_current_location(i16 noundef 0) #14, !dbg !845
  br label %if.end19, !dbg !853

if.end19:                                         ; preds = %if.end19.critedge, %if.then
  ret void, !dbg !854
}

; Function Attrs: minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none)
define dso_local void @nothing_int() local_unnamed_addr #7 !dbg !855 {
entry:
  ret void, !dbg !856
}

; Function Attrs: minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none)
define dso_local void @refresh_crt_dma_50hz_interrupt() local_unnamed_addr #8 !dbg !857 {
entry:
  %0 = load volatile i8, ptr addrspace(2) inttoptr (i16 1 to ptr addrspace(2)), align 1, !dbg !863, !tbaa !186
    #dbg_value(i8 6, !570, !DIExpression(), !866)
  store volatile i8 6, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !868, !tbaa !186
    #dbg_value(i8 0, !582, !DIExpression(), !869)
  store volatile i8 0, ptr addrspace(2) inttoptr (i16 252 to ptr addrspace(2)), align 4, !dbg !871, !tbaa !186
    #dbg_value(i16 30768, !859, !DIExpression(), !872)
    #dbg_value(i8 48, !873, !DIExpression(), !876)
  store volatile i8 48, ptr addrspace(2) inttoptr (i16 244 to ptr addrspace(2)), align 4, !dbg !878, !tbaa !186
    #dbg_value(i8 120, !873, !DIExpression(), !879)
  store volatile i8 120, ptr addrspace(2) inttoptr (i16 244 to ptr addrspace(2)), align 4, !dbg !881, !tbaa !186
    #dbg_value(i16 1999, !861, !DIExpression(), !882)
    #dbg_value(i8 -49, !883, !DIExpression(), !886)
  store volatile i8 -49, ptr addrspace(2) inttoptr (i16 245 to ptr addrspace(2)), align 1, !dbg !888, !tbaa !186
    #dbg_value(i8 7, !883, !DIExpression(), !889)
  store volatile i8 7, ptr addrspace(2) inttoptr (i16 245 to ptr addrspace(2)), align 1, !dbg !891, !tbaa !186
    #dbg_value(i8 2, !570, !DIExpression(), !892)
  store volatile i8 2, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !894, !tbaa !186
    #dbg_value(i8 -41, !895, !DIExpression(), !898)
  store volatile i8 -41, ptr addrspace(2) inttoptr (i16 14 to ptr addrspace(2)), align 2, !dbg !900, !tbaa !186
    #dbg_value(i8 1, !895, !DIExpression(), !901)
  store volatile i8 1, ptr addrspace(2) inttoptr (i16 14 to ptr addrspace(2)), align 2, !dbg !903, !tbaa !186
  ret void, !dbg !904
}

; Function Attrs: minsize nounwind optsize
define dso_local void @floppy_completed_operation_interrupt() local_unnamed_addr #9 !dbg !905 {
entry:
  store volatile i8 2, ptr @floppy_operation_completed_flag, align 1, !dbg !906, !tbaa !186
  %0 = load volatile i8, ptr addrspace(2) inttoptr (i16 4 to ptr addrspace(2)), align 4, !dbg !907, !tbaa !186
  %1 = and i8 %0, 16, !dbg !910
  %tobool.not = icmp eq i8 %1, 0, !dbg !911
  br i1 %tobool.not, label %if.else, label %if.then, !dbg !912

if.then:                                          ; preds = %entry
  tail call void @fdc_read_result() #14, !dbg !913
  br label %if.end, !dbg !915

if.else:                                          ; preds = %entry
  tail call void @fdc_sense_interrupt() #14, !dbg !916
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void, !dbg !918
}

; Function Attrs: minsize noreturn nounwind optsize
define dso_local void @main_relocated() local_unnamed_addr #4 !dbg !919 {
entry:
  tail call void asm sideeffect "ld sp, 0xBFFF", ""() #13, !dbg !920, !srcloc !921
    #dbg_value(i8 96, !922, !DIExpression(), !927)
  tail call void asm sideeffect "ld i, a", "a"(i8 96) #13, !dbg !929, !srcloc !930
  tail call void asm sideeffect "im 2", ""() #13, !dbg !931, !srcloc !934
    #dbg_value(i8 2, !935, !DIExpression(), !938)
  store volatile i8 2, ptr addrspace(2) inttoptr (i16 18 to ptr addrspace(2)), align 2, !dbg !942, !tbaa !186
    #dbg_value(i8 4, !943, !DIExpression(), !946)
  store volatile i8 4, ptr addrspace(2) inttoptr (i16 19 to ptr addrspace(2)), align 1, !dbg !948, !tbaa !186
    #dbg_value(i8 79, !935, !DIExpression(), !949)
  store volatile i8 79, ptr addrspace(2) inttoptr (i16 18 to ptr addrspace(2)), align 2, !dbg !951, !tbaa !186
    #dbg_value(i8 15, !943, !DIExpression(), !952)
  store volatile i8 15, ptr addrspace(2) inttoptr (i16 19 to ptr addrspace(2)), align 1, !dbg !954, !tbaa !186
    #dbg_value(i8 -125, !935, !DIExpression(), !955)
  store volatile i8 -125, ptr addrspace(2) inttoptr (i16 18 to ptr addrspace(2)), align 2, !dbg !957, !tbaa !186
    #dbg_value(i8 -125, !943, !DIExpression(), !958)
  store volatile i8 -125, ptr addrspace(2) inttoptr (i16 19 to ptr addrspace(2)), align 1, !dbg !960, !tbaa !186
    #dbg_value(i8 8, !961, !DIExpression(), !964)
  store volatile i8 8, ptr addrspace(2) inttoptr (i16 12 to ptr addrspace(2)), align 4, !dbg !968, !tbaa !186
    #dbg_value(i8 71, !961, !DIExpression(), !969)
  store volatile i8 71, ptr addrspace(2) inttoptr (i16 12 to ptr addrspace(2)), align 4, !dbg !971, !tbaa !186
    #dbg_value(i8 32, !961, !DIExpression(), !972)
  store volatile i8 32, ptr addrspace(2) inttoptr (i16 12 to ptr addrspace(2)), align 4, !dbg !974, !tbaa !186
    #dbg_value(i8 71, !975, !DIExpression(), !978)
  store volatile i8 71, ptr addrspace(2) inttoptr (i16 13 to ptr addrspace(2)), align 1, !dbg !980, !tbaa !186
    #dbg_value(i8 32, !975, !DIExpression(), !981)
  store volatile i8 32, ptr addrspace(2) inttoptr (i16 13 to ptr addrspace(2)), align 1, !dbg !983, !tbaa !186
    #dbg_value(i8 -41, !895, !DIExpression(), !984)
  store volatile i8 -41, ptr addrspace(2) inttoptr (i16 14 to ptr addrspace(2)), align 2, !dbg !986, !tbaa !186
    #dbg_value(i8 1, !895, !DIExpression(), !987)
  store volatile i8 1, ptr addrspace(2) inttoptr (i16 14 to ptr addrspace(2)), align 2, !dbg !989, !tbaa !186
    #dbg_value(i8 -41, !656, !DIExpression(), !990)
  store volatile i8 -41, ptr addrspace(2) inttoptr (i16 15 to ptr addrspace(2)), align 1, !dbg !992, !tbaa !186
    #dbg_value(i8 1, !656, !DIExpression(), !993)
  store volatile i8 1, ptr addrspace(2) inttoptr (i16 15 to ptr addrspace(2)), align 1, !dbg !995, !tbaa !186
    #dbg_value(i8 32, !996, !DIExpression(), !999)
  store volatile i8 32, ptr addrspace(2) inttoptr (i16 248 to ptr addrspace(2)), align 8, !dbg !1003, !tbaa !186
    #dbg_value(i8 -64, !576, !DIExpression(), !1004)
  store volatile i8 -64, ptr addrspace(2) inttoptr (i16 251 to ptr addrspace(2)), align 1, !dbg !1006, !tbaa !186
    #dbg_value(i8 0, !570, !DIExpression(), !1007)
  store volatile i8 0, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !1009, !tbaa !186
    #dbg_value(i8 74, !576, !DIExpression(), !1010)
  store volatile i8 74, ptr addrspace(2) inttoptr (i16 251 to ptr addrspace(2)), align 1, !dbg !1012, !tbaa !186
    #dbg_value(i8 0, !1013, !DIExpression(), !1016)
  store volatile i8 0, ptr addrspace(2) inttoptr (i16 1 to ptr addrspace(2)), align 1, !dbg !1020, !tbaa !186
    #dbg_value(i8 79, !1021, !DIExpression(), !1024)
  store volatile i8 79, ptr addrspace(2) null, align 32768, !dbg !1026, !tbaa !186
    #dbg_value(i8 -104, !1021, !DIExpression(), !1027)
  store volatile i8 -104, ptr addrspace(2) null, align 32768, !dbg !1029, !tbaa !186
    #dbg_value(i8 -102, !1021, !DIExpression(), !1030)
  store volatile i8 -102, ptr addrspace(2) null, align 32768, !dbg !1032, !tbaa !186
    #dbg_value(i8 93, !1021, !DIExpression(), !1033)
  store volatile i8 93, ptr addrspace(2) null, align 32768, !dbg !1035, !tbaa !186
    #dbg_value(i8 -128, !1013, !DIExpression(), !1036)
  store volatile i8 -128, ptr addrspace(2) inttoptr (i16 1 to ptr addrspace(2)), align 1, !dbg !1038, !tbaa !186
    #dbg_value(i8 0, !1021, !DIExpression(), !1039)
  store volatile i8 0, ptr addrspace(2) null, align 32768, !dbg !1041, !tbaa !186
    #dbg_value(i8 0, !1021, !DIExpression(), !1042)
  store volatile i8 0, ptr addrspace(2) null, align 32768, !dbg !1044, !tbaa !186
    #dbg_value(i8 -32, !1013, !DIExpression(), !1045)
  store volatile i8 -32, ptr addrspace(2) inttoptr (i16 1 to ptr addrspace(2)), align 1, !dbg !1047, !tbaa !186
  tail call fastcc void @load_chargen_font() #14, !dbg !1048
  tail call void @delay(i8 noundef zeroext 2, i8 noundef zeroext -66) #14, !dbg !1049
  br label %while.cond.i, !dbg !1052

while.cond.i:                                     ; preds = %while.cond.i, %entry
  %0 = load volatile i8, ptr addrspace(2) inttoptr (i16 4 to ptr addrspace(2)), align 4, !dbg !1053, !tbaa !186
  %1 = and i8 %0, 31, !dbg !1055
  %tobool.not.i = icmp eq i8 %1, 0, !dbg !1056
  br i1 %tobool.not.i, label %init_fdc.exit, label %while.cond.i, !dbg !1057, !llvm.loop !1058

init_fdc.exit:                                    ; preds = %while.cond.i
  tail call void @fdc_write_when_ready(i8 noundef zeroext 3) #14, !dbg !1060
  tail call void @fdc_write_when_ready(i8 noundef zeroext 79) #14, !dbg !1061
  tail call void @fdc_write_when_ready(i8 noundef zeroext 32) #14, !dbg !1062
  tail call void @llvm.memset.p0.i16(ptr noundef nonnull align 16 dereferenceable(2000) inttoptr (i16 30768 to ptr), i8 32, i16 2000, i1 false), !dbg !1063
  tail call fastcc void @display_banner_and_start_crt() #14, !dbg !1064
  store i8 3, ptr @fdc_isr_delay, align 1, !dbg !1065, !tbaa !186
  store i8 4, ptr @fdc_result_delay, align 1, !dbg !1068, !tbaa !186
  %2 = load volatile i8, ptr addrspace(2) inttoptr (i16 20 to ptr addrspace(2)), align 4, !dbg !1069, !tbaa !186
  %3 = lshr i8 %2, 7, !dbg !1071
  store i8 %3, ptr @is_mini, align 1, !dbg !1072, !tbaa !186
  tail call void asm sideeffect "ei", ""() #13, !dbg !1073, !srcloc !393
    #dbg_value(i8 1, !1075, !DIExpression(), !1078)
  store volatile i8 1, ptr addrspace(2) inttoptr (i16 20 to ptr addrspace(2)), align 4, !dbg !1080, !tbaa !186
  store i8 5, ptr @retry_count, align 1, !dbg !1081, !tbaa !186
  tail call fastcc void @boot_from_floppy_or_jump_prom1() #14, !dbg !1082
  br label %for.cond, !dbg !1083

for.cond:                                         ; preds = %for.cond, %init_fdc.exit
  br label %for.cond, !dbg !1084, !llvm.loop !1087
}

; Function Attrs: alwaysinline minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none)
define internal fastcc void @load_chargen_font() unnamed_addr #10 !dbg !1090 {
entry:
    #dbg_value(ptr @sem702_font, !1094, !DIExpression(), !1095)
    #dbg_value(i8 0, !1092, !DIExpression(), !1095)
  br label %for.cond, !dbg !1096

for.cond:                                         ; preds = %for.inc7, %entry
  %line.0 = phi i8 [ 0, %entry ], [ %inc8, %for.inc7 ], !dbg !1098
  %p.0 = phi ptr [ @sem702_font, %entry ], [ %p.1, %for.inc7 ], !dbg !1099
    #dbg_value(ptr %p.0, !1094, !DIExpression(), !1095)
    #dbg_value(i8 %line.0, !1092, !DIExpression(), !1095)
  %exitcond14.not = icmp eq i8 %line.0, 11, !dbg !1100
  br i1 %exitcond14.not, label %for.end9, label %for.body, !dbg !1102

for.body:                                         ; preds = %for.cond
    #dbg_value(i8 %line.0, !1103, !DIExpression(), !1106)
  store volatile i8 %line.0, ptr addrspace(2) inttoptr (i16 210 to ptr addrspace(2)), align 2, !dbg !1109, !tbaa !186
    #dbg_value(i8 0, !1093, !DIExpression(), !1095)
  br label %for.cond2, !dbg !1110

for.cond2:                                        ; preds = %for.body6, %for.body
  %ch.0 = phi i8 [ 0, %for.body ], [ %inc, %for.body6 ], !dbg !1112
  %p.1 = phi ptr [ %p.0, %for.body ], [ %incdec.ptr, %for.body6 ], !dbg !1095
    #dbg_value(ptr %p.1, !1094, !DIExpression(), !1095)
    #dbg_value(i8 %ch.0, !1093, !DIExpression(), !1095)
  %exitcond.not = icmp eq i8 %ch.0, -128, !dbg !1113
  br i1 %exitcond.not, label %for.inc7, label %for.body6, !dbg !1115

for.body6:                                        ; preds = %for.cond2
    #dbg_value(i8 %ch.0, !1116, !DIExpression(), !1119)
  store volatile i8 %ch.0, ptr addrspace(2) inttoptr (i16 209 to ptr addrspace(2)), align 1, !dbg !1122, !tbaa !186
  %incdec.ptr = getelementptr inbounds nuw i8, ptr %p.1, i16 1, !dbg !1123
    #dbg_value(ptr %incdec.ptr, !1094, !DIExpression(), !1095)
  %0 = load i8, ptr %p.1, align 1, !dbg !1124, !tbaa !186
    #dbg_value(i8 %0, !1125, !DIExpression(), !1128)
  store volatile i8 %0, ptr addrspace(2) inttoptr (i16 211 to ptr addrspace(2)), align 1, !dbg !1130, !tbaa !186
  %inc = add nuw i8 %ch.0, 1, !dbg !1131
    #dbg_value(i8 %inc, !1093, !DIExpression(), !1095)
  br label %for.cond2, !dbg !1132, !llvm.loop !1133

for.inc7:                                         ; preds = %for.cond2
  %inc8 = add nuw nsw i8 %line.0, 1, !dbg !1136
    #dbg_value(i8 %inc8, !1092, !DIExpression(), !1095)
  br label %for.cond, !dbg !1137, !llvm.loop !1138

for.end9:                                         ; preds = %for.cond
  ret void, !dbg !1141
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i16(ptr writeonly captures(none), i8, i16, i1 immarg) #11

; Function Attrs: alwaysinline minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none)
define internal fastcc void @display_banner_and_start_crt() unnamed_addr #10 !dbg !1142 {
entry:
  tail call void @llvm.memset.p0.i16(ptr noundef nonnull align 2 dereferenceable(1954) inttoptr (i16 30814 to ptr), i8 32, i16 1954, i1 false), !dbg !1148
  tail call void @llvm.memcpy.p0.p0.i16(ptr noundef nonnull align 16 dereferenceable(46) inttoptr (i16 30768 to ptr), ptr noundef nonnull align 1 dereferenceable(46) @banner_string, i16 46, i1 false), !dbg !1149
  tail call fastcc void @display_sw1_status() #14, !dbg !1150
  tail call fastcc void @draw_qr() #14, !dbg !1151
    #dbg_value(i8 6, !570, !DIExpression(), !1152)
  store volatile i8 6, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !1154, !tbaa !186
    #dbg_value(i8 0, !582, !DIExpression(), !1155)
  store volatile i8 0, ptr addrspace(2) inttoptr (i16 252 to ptr addrspace(2)), align 4, !dbg !1157, !tbaa !186
    #dbg_value(i16 30768, !1144, !DIExpression(), !1158)
    #dbg_value(i8 48, !873, !DIExpression(), !1159)
  store volatile i8 48, ptr addrspace(2) inttoptr (i16 244 to ptr addrspace(2)), align 4, !dbg !1161, !tbaa !186
    #dbg_value(i8 120, !873, !DIExpression(), !1162)
  store volatile i8 120, ptr addrspace(2) inttoptr (i16 244 to ptr addrspace(2)), align 4, !dbg !1164, !tbaa !186
    #dbg_value(i16 1999, !1146, !DIExpression(), !1165)
    #dbg_value(i8 -49, !883, !DIExpression(), !1166)
  store volatile i8 -49, ptr addrspace(2) inttoptr (i16 245 to ptr addrspace(2)), align 1, !dbg !1168, !tbaa !186
    #dbg_value(i8 7, !883, !DIExpression(), !1169)
  store volatile i8 7, ptr addrspace(2) inttoptr (i16 245 to ptr addrspace(2)), align 1, !dbg !1171, !tbaa !186
    #dbg_value(i8 2, !570, !DIExpression(), !1172)
  store volatile i8 2, ptr addrspace(2) inttoptr (i16 250 to ptr addrspace(2)), align 2, !dbg !1174, !tbaa !186
    #dbg_value(i8 35, !1013, !DIExpression(), !1175)
  store volatile i8 35, ptr addrspace(2) inttoptr (i16 1 to ptr addrspace(2)), align 1, !dbg !1177, !tbaa !186
  ret void, !dbg !1178
}

; Function Attrs: alwaysinline minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none)
define internal fastcc void @display_sw1_status() unnamed_addr #10 !dbg !152 {
entry:
  %0 = load volatile i8, ptr addrspace(2) inttoptr (i16 20 to ptr addrspace(2)), align 4, !dbg !1179, !tbaa !186
    #dbg_value(i8 %0, !154, !DIExpression(), !1181)
    #dbg_value(ptr inttoptr (i16 30826 to ptr), !155, !DIExpression(), !1181)
  tail call void @llvm.memcpy.p0.p0.i16(ptr noundef nonnull align 2 dereferenceable(14) inttoptr (i16 30826 to ptr), ptr noundef nonnull align 1 dereferenceable(14) @display_sw1_status.prefix, i16 14, i1 false), !dbg !1182
    #dbg_value(ptr inttoptr (i16 30840 to ptr), !155, !DIExpression(), !1181)
    #dbg_value(i8 0, !156, !DIExpression(), !1181)
  br label %for.cond, !dbg !1183

for.cond:                                         ; preds = %for.body, %entry
  %sw.0 = phi i8 [ %0, %entry ], [ %1, %for.body ], !dbg !1181
  %p.0 = phi ptr [ inttoptr (i16 30840 to ptr), %entry ], [ %incdec.ptr, %for.body ], !dbg !1181
  %i.0 = phi i8 [ 0, %entry ], [ %inc, %for.body ], !dbg !1185
    #dbg_value(i8 %i.0, !156, !DIExpression(), !1181)
    #dbg_value(ptr %p.0, !155, !DIExpression(), !1181)
    #dbg_value(i8 %sw.0, !154, !DIExpression(), !1181)
  %exitcond.not = icmp eq i8 %i.0, 8, !dbg !1186
  br i1 %exitcond.not, label %for.end, label %for.body, !dbg !1188

for.body:                                         ; preds = %for.cond
  %and = and i8 %sw.0, 1, !dbg !1189
  %add = or disjoint i8 %and, 48, !dbg !1191
  %incdec.ptr = getelementptr inbounds nuw i8, ptr %p.0, i16 1, !dbg !1192
    #dbg_value(ptr %incdec.ptr, !155, !DIExpression(), !1181)
  store i8 %add, ptr %p.0, align 1, !dbg !1193, !tbaa !186
  %1 = lshr i8 %sw.0, 1, !dbg !1194
    #dbg_value(i8 %1, !154, !DIExpression(), !1181)
  %inc = add nuw nsw i8 %i.0, 1, !dbg !1195
    #dbg_value(i8 %inc, !156, !DIExpression(), !1181)
  br label %for.cond, !dbg !1196, !llvm.loop !1197

for.end:                                          ; preds = %for.cond
  ret void, !dbg !1200
}

; Function Attrs: alwaysinline minsize nofree norecurse nosync nounwind optsize memory(write, inaccessiblemem: none, target_mem: none)
define internal fastcc void @draw_qr() unnamed_addr #12 !dbg !1201 {
entry:
    #dbg_value(ptr @qr_screen, !1203, !DIExpression(), !1207)
    #dbg_value(ptr inttoptr (i16 31970 to ptr), !1204, !DIExpression(), !1207)
  store i8 -124, ptr inttoptr (i16 31969 to ptr), align 1, !dbg !1208, !tbaa !186
    #dbg_value(i8 0, !1205, !DIExpression(), !1207)
  br label %for.cond, !dbg !1209

for.cond:                                         ; preds = %for.end, %entry
  %s.0 = phi ptr [ @qr_screen, %entry ], [ %s.1, %for.end ], !dbg !1211
  %d.0 = phi ptr [ inttoptr (i16 31970 to ptr), %entry ], [ %add.ptr, %for.end ], !dbg !1207
  %r.0 = phi i8 [ 0, %entry ], [ %inc9, %for.end ], !dbg !1212
    #dbg_value(i8 %r.0, !1205, !DIExpression(), !1207)
    #dbg_value(ptr %d.0, !1204, !DIExpression(), !1207)
    #dbg_value(ptr %s.0, !1203, !DIExpression(), !1207)
  %exitcond15.not = icmp eq i8 %r.0, 9, !dbg !1213
  br i1 %exitcond15.not, label %for.end10, label %for.cond2, !dbg !1215

for.cond2:                                        ; preds = %for.body6, %for.cond
  %s.1 = phi ptr [ %incdec.ptr, %for.body6 ], [ %s.0, %for.cond ], !dbg !1207
  %d.1 = phi ptr [ %incdec.ptr7, %for.body6 ], [ %d.0, %for.cond ], !dbg !1207
  %c.0 = phi i8 [ %inc, %for.body6 ], [ 0, %for.cond ], !dbg !1216
    #dbg_value(i8 %c.0, !1206, !DIExpression(), !1207)
    #dbg_value(ptr %d.1, !1204, !DIExpression(), !1207)
    #dbg_value(ptr %s.1, !1203, !DIExpression(), !1207)
  %exitcond.not = icmp eq i8 %c.0, 13, !dbg !1219
  br i1 %exitcond.not, label %for.end, label %for.body6, !dbg !1221

for.body6:                                        ; preds = %for.cond2
  %incdec.ptr = getelementptr inbounds nuw i8, ptr %s.1, i16 1, !dbg !1222
    #dbg_value(ptr %incdec.ptr, !1203, !DIExpression(), !1207)
  %0 = load i8, ptr %s.1, align 1, !dbg !1223, !tbaa !186
  %incdec.ptr7 = getelementptr inbounds nuw i8, ptr %d.1, i16 1, !dbg !1224
    #dbg_value(ptr %incdec.ptr7, !1204, !DIExpression(), !1207)
  store i8 %0, ptr %d.1, align 1, !dbg !1225, !tbaa !186
  %inc = add nuw nsw i8 %c.0, 1, !dbg !1226
    #dbg_value(i8 %inc, !1206, !DIExpression(), !1207)
  br label %for.cond2, !dbg !1227, !llvm.loop !1228

for.end:                                          ; preds = %for.cond2
  %add.ptr = getelementptr inbounds nuw i8, ptr %d.1, i16 67, !dbg !1231
    #dbg_value(ptr %add.ptr, !1204, !DIExpression(), !1207)
  %inc9 = add nuw nsw i8 %r.0, 1, !dbg !1232
    #dbg_value(i8 %inc9, !1205, !DIExpression(), !1207)
  br label %for.cond, !dbg !1233, !llvm.loop !1234

for.end10:                                        ; preds = %for.cond
  ret void, !dbg !1237
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @boot_from_floppy_or_jump_prom1() unnamed_addr #1 !dbg !1238 {
entry:
  tail call void @delay(i8 noundef zeroext 2, i8 noundef zeroext -66) #14, !dbg !1241
  tail call void @fdc_write_when_ready(i8 noundef zeroext 4) #14, !dbg !1242
  %0 = load i8, ptr @drive_select, align 1, !dbg !1243, !tbaa !186
  tail call void @fdc_write_when_ready(i8 noundef zeroext %0) #14, !dbg !1244
  %call = tail call zeroext i8 @fdc_read_when_ready() #14, !dbg !1245
  store i8 %call, ptr @fdc_result, align 1, !dbg !1246, !tbaa !337
  %1 = and i8 %call, 35, !dbg !1247
    #dbg_value(i8 %1, !1240, !DIExpression(), !1248)
  tail call void @fdc_write_when_ready(i8 noundef zeroext 7) #14, !dbg !1249
  %2 = load i8, ptr @drive_select, align 1, !dbg !1250, !tbaa !186
  tail call void @fdc_write_when_ready(i8 noundef zeroext %2) #14, !dbg !1251
  %conv2 = zext nneg i8 %1 to i16, !dbg !1252
  %3 = load i8, ptr @drive_select, align 1, !dbg !1254, !tbaa !186
  %conv3 = zext i8 %3 to i16, !dbg !1254
  %add = add nuw nsw i16 %conv3, 32, !dbg !1255
  %cmp.not = icmp eq i16 %add, %conv2, !dbg !1256
  br i1 %cmp.not, label %lor.lhs.false, label %cleanup, !dbg !1257

lor.lhs.false:                                    ; preds = %entry
  %call5 = tail call fastcc zeroext i8 @verify_seek_result(i8 noundef zeroext 0) #14, !dbg !1258
  %cmp7.not = icmp eq i8 %call5, 0, !dbg !1259
  br i1 %cmp7.not, label %if.end, label %cleanup, !dbg !1260

if.end:                                           ; preds = %lor.lhs.false
  store i8 0, ptr @fdc_cmd, align 1, !dbg !1261, !tbaa !443
  store i8 1, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !1262, !tbaa !303
  store i8 1, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 2), align 1, !dbg !1263, !tbaa !308
  %call9 = tail call zeroext i8 @fdc_detect_sector_size_and_density() #14, !dbg !1264
  %cmp11 = icmp eq i8 %call9, 0, !dbg !1266
  br i1 %cmp11, label %if.then13, label %if.end14, !dbg !1267

if.then13:                                        ; preds = %if.end
  store i1 true, ptr @is_double_sided, align 1, !dbg !1268
  br label %if.end14, !dbg !1270

if.end14:                                         ; preds = %if.then13, %if.end
  store i8 0, ptr getelementptr inbounds nuw (i8, ptr @fdc_cmd, i16 1), align 1, !dbg !1271, !tbaa !303
  %call15 = tail call zeroext i8 @fdc_detect_sector_size_and_density() #14, !dbg !1272
  %cmp17.not = icmp eq i8 %call15, 0, !dbg !1274
  br i1 %cmp17.not, label %if.end20, label %cleanup, !dbg !1275

if.end20:                                         ; preds = %if.end14
    #dbg_value(i8 1, !1276, !DIExpression(), !1279)
  store volatile i8 1, ptr addrspace(2) inttoptr (i16 24 to ptr addrspace(2)), align 8, !dbg !1281, !tbaa !186
  br label %while.cond, !dbg !1282

while.cond:                                       ; preds = %if.end25, %if.end20
  %4 = load i16, ptr @dma_transfer_size, align 1, !dbg !1283, !tbaa !324
  tail call fastcc void @fdc_read_data_from_current_location(i16 noundef %4) #14, !dbg !1285
  %5 = load i8, ptr @fdc_cmd, align 1, !dbg !1286, !tbaa !443
  %cmp22.not = icmp eq i8 %5, 0, !dbg !1288
  br i1 %cmp22.not, label %if.end25, label %while.end, !dbg !1289

if.end25:                                         ; preds = %while.cond
  %call26 = tail call zeroext i8 @fdc_detect_sector_size_and_density() #14, !dbg !1290
  br label %while.cond, !dbg !1282, !llvm.loop !1291

while.end:                                        ; preds = %while.cond
  store i8 1, ptr @disk_type, align 1, !dbg !1293, !tbaa !186
  tail call fastcc void @boot_floppy_or_prom() #15, !dbg !1294
  unreachable, !dbg !1294

cleanup:                                          ; preds = %if.end14, %lor.lhs.false, %entry
  tail call void @prom1_if_present() #14, !dbg !1248
  ret void, !dbg !1295
}

; Function Attrs: minsize noreturn nounwind optsize
define internal fastcc void @boot_floppy_or_prom() unnamed_addr #4 !dbg !1296 {
entry:
  %call = tail call zeroext i8 @compare_6bytes(ptr noundef nonnull inttoptr (i16 2 to ptr), ptr noundef nonnull @.str.2) #14, !dbg !1297
  %cmp = icmp eq i8 %call, 0, !dbg !1299
  br i1 %cmp, label %while.cond, label %if.end24, !dbg !1300

while.cond:                                       ; preds = %if.then7, %entry
  %storemerge = phi ptr [ %add.ptr, %if.then7 ], [ inttoptr (i16 2944 to ptr), %entry ], !dbg !1301
  store ptr %storemerge, ptr @boot_dir, align 1, !dbg !1301, !tbaa !1303
  %cmp2 = icmp samesign ult ptr %storemerge, inttoptr (i16 3328 to ptr), !dbg !1306
  br i1 %cmp2, label %while.body, label %do.body, !dbg !1307

while.body:                                       ; preds = %while.cond
  %0 = load i8, ptr %storemerge, align 1, !dbg !1308, !tbaa !186
  %cmp5 = icmp eq i8 %0, 0, !dbg !1311
  br i1 %cmp5, label %if.then7, label %if.end, !dbg !1312

if.then7:                                         ; preds = %while.body
  %add.ptr = getelementptr inbounds nuw i8, ptr %storemerge, i16 32, !dbg !1313
  br label %while.cond, !dbg !1315, !llvm.loop !1316

if.end:                                           ; preds = %while.body
  %call8 = tail call zeroext i8 @check_sysfile(ptr noundef nonnull %storemerge, ptr noundef nonnull @.str.3) #14, !dbg !1319
  %cmp10 = icmp eq i8 %call8, 0, !dbg !1321
  br i1 %cmp10, label %if.then12, label %do.body, !dbg !1322

if.then12:                                        ; preds = %if.end
  %add.ptr13 = getelementptr inbounds nuw i8, ptr %storemerge, i16 32, !dbg !1323
  store ptr %add.ptr13, ptr @boot_dir, align 1, !dbg !1325, !tbaa !1303
  %1 = load i8, ptr %add.ptr13, align 1, !dbg !1326, !tbaa !186
  %cmp15.not = icmp eq i8 %1, 0, !dbg !1328
  br i1 %cmp15.not, label %do.body, label %land.lhs.true, !dbg !1329

land.lhs.true:                                    ; preds = %if.then12
  %call17 = tail call zeroext i8 @check_sysfile(ptr noundef nonnull %add.ptr13, ptr noundef nonnull @.str.4) #14, !dbg !1330
  %cmp19 = icmp eq i8 %call17, 0, !dbg !1331
  br i1 %cmp19, label %if.then21, label %do.body, !dbg !1332

if.then21:                                        ; preds = %land.lhs.true
  tail call void @floppy_legacy_boot() #14, !dbg !1333
  br label %do.body, !dbg !1335

do.body:                                          ; preds = %if.then21, %land.lhs.true, %if.then12, %if.end, %while.cond
  tail call void @llvm.memcpy.p0.p0.i16(ptr noundef nonnull align 16 dereferenceable(21) inttoptr (i16 30928 to ptr), ptr noundef nonnull align 1 dereferenceable(21) @.str.5, i16 21, i1 false), !dbg !1336
  tail call void @halt_forever() #15, !dbg !1338
  unreachable, !dbg !1338

if.end24:                                         ; preds = %entry
  %call25 = tail call zeroext i8 @compare_6bytes(ptr noundef nonnull inttoptr (i16 8 to ptr), ptr noundef nonnull @msg_rc702) #14, !dbg !1339
  %cmp27 = icmp eq i8 %call25, 0, !dbg !1341
  br i1 %cmp27, label %if.then29, label %do.body31, !dbg !1342

if.then29:                                        ; preds = %if.end24
  %2 = load volatile i16, ptr null, align 32768, !dbg !1343, !tbaa !324
  %3 = inttoptr i16 %2 to ptr, !dbg !1345
  tail call void %3() #16, !dbg !1345
  br label %do.body31, !dbg !1346

do.body31:                                        ; preds = %if.then29, %if.end24
  tail call void @llvm.memcpy.p0.p0.i16(ptr noundef nonnull align 16 dereferenceable(16) inttoptr (i16 30928 to ptr), ptr noundef nonnull align 1 dereferenceable(16) @.str.6, i16 16, i1 false), !dbg !1347
  tail call void @halt_forever() #15, !dbg !1349
  unreachable, !dbg !1349
}

attributes #0 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #1 = { minsize nounwind optsize "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #2 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(readwrite, argmem: none, inaccessiblemem: none, target_mem: none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #3 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, argmem: none, inaccessiblemem: none, target_mem: none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #4 = { minsize noreturn nounwind optsize "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #5 = { minsize nofree norecurse nosync nounwind optsize memory(argmem: read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { minsize mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) "frame-pointer"="all" "interrupt" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #8 = { minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none) "frame-pointer"="all" "interrupt" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #9 = { minsize nounwind optsize "frame-pointer"="all" "interrupt" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #10 = { alwaysinline minsize nofree norecurse nosync nounwind optsize memory(readwrite, target_mem: none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #11 = { nocallback nofree nosync nounwind willreturn memory(argmem: write) }
attributes #12 = { alwaysinline minsize nofree norecurse nosync nounwind optsize memory(write, inaccessiblemem: none, target_mem: none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+shadow-isr,+static-frame" }
attributes #13 = { nounwind }
attributes #14 = { minsize optsize }
attributes #15 = { minsize noreturn optsize }
attributes #16 = { minsize nounwind optsize }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!160, !161, !162, !163, !164}
!llvm.ident = !{!165}
!llvm.errno.tbaa = !{!166}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "eot_gap3_table", scope: !2, file: !32, line: 336, type: !139, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 24.0.0git (git@github.com:ravn/llvm-z80.git d6658ad190659796ca1ea316de6f4fd17def8193)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !29, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/Users/ravn/z80/scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/rom.c", directory: "/Users/ravn/z80", checksumkind: CSK_MD5, checksum: "9d489da99b3f2f0853fd8f04eab4382d")
!4 = !{!5, !10, !11, !14, !15, !17, !20, !21, !12, !23, !25, !26, !27}
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "word", file: !6, line: 43, baseType: !7)
!6 = !DIFile(filename: "scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/rom.h", directory: "/Users/ravn/z80", checksumkind: CSK_MD5, checksum: "423dd4bfeb1ab7207925a3646760debf")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !8, line: 247, baseType: !9)
!8 = !DIFile(filename: "llvm-z80/build-macos-asserts/lib/clang/24/include/stdint.h", directory: "/Users/ravn/z80", checksumkind: CSK_MD5, checksum: "e0d709cfd45c240304ff650668138b52")
!9 = !DIBasicType(name: "unsigned int", size: 16, encoding: DW_ATE_unsigned)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 16)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "byte", file: !6, line: 42, baseType: !12)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !8, line: 270, baseType: !13)
!13 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!14 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 16)
!16 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !11)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 16)
!18 = !DISubroutineType(types: !19)
!19 = !{null}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 16)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 16)
!22 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !12)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !8, line: 245, baseType: !24)
!24 = !DIBasicType(name: "int", size: 16, encoding: DW_ATE_signed)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 16)
!26 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 16)
!28 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !5)
!29 = !{!30, !44, !46, !48, !50, !62, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !88, !93, !95, !0, !97, !103, !105, !111, !117, !120, !125, !127, !132, !137}
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "fdc_result", scope: !2, file: !32, line: 598, type: !33, isLocal: false, isDefinition: true)
!32 = !DIFile(filename: "scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/rom.c", directory: "/Users/ravn/z80", checksumkind: CSK_MD5, checksum: "9d489da99b3f2f0853fd8f04eab4382d")
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "fdc_result_block", file: !6, line: 314, baseType: !34)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 305, size: 64, elements: !35)
!35 = !{!36, !37, !38, !39, !40, !41, !42, !43}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "st0", scope: !34, file: !6, line: 306, baseType: !11, size: 8)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "st1", scope: !34, file: !6, line: 307, baseType: !11, size: 8, offset: 8)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "st2", scope: !34, file: !6, line: 308, baseType: !11, size: 8, offset: 16)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "cylinder", scope: !34, file: !6, line: 309, baseType: !11, size: 8, offset: 24)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !34, file: !6, line: 310, baseType: !11, size: 8, offset: 32)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "sector", scope: !34, file: !6, line: 311, baseType: !11, size: 8, offset: 40)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "size_code", scope: !34, file: !6, line: 312, baseType: !11, size: 8, offset: 48)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "dma_status", scope: !34, file: !6, line: 313, baseType: !11, size: 8, offset: 56)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "drive_select", scope: !2, file: !32, line: 599, type: !11, isLocal: false, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(name: "fdc_isr_delay", scope: !2, file: !32, line: 600, type: !11, isLocal: false, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(name: "fdc_result_delay", scope: !2, file: !32, line: 601, type: !11, isLocal: false, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "fdc_cmd", scope: !2, file: !32, line: 602, type: !52, isLocal: false, isDefinition: true)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "fdc_command_block", file: !6, line: 330, baseType: !53)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 322, size: 56, elements: !54)
!54 = !{!55, !56, !57, !58, !59, !60, !61}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "cylinder", scope: !53, file: !6, line: 323, baseType: !11, size: 8)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "head", scope: !53, file: !6, line: 324, baseType: !11, size: 8, offset: 8)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "sector", scope: !53, file: !6, line: 325, baseType: !11, size: 8, offset: 16)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "size_shift", scope: !53, file: !6, line: 326, baseType: !11, size: 8, offset: 24)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "eot", scope: !53, file: !6, line: 327, baseType: !11, size: 8, offset: 32)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "gap3", scope: !53, file: !6, line: 328, baseType: !11, size: 8, offset: 40)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "dtl", scope: !53, file: !6, line: 329, baseType: !11, size: 8, offset: 48)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "floppy_operation_completed_flag", scope: !2, file: !32, line: 603, type: !64, isLocal: false, isDefinition: true)
!64 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !11)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "is_mini", scope: !2, file: !32, line: 604, type: !11, isLocal: false, isDefinition: true)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "is_mfm", scope: !2, file: !32, line: 605, type: !11, isLocal: false, isDefinition: true)
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "disk_type", scope: !2, file: !32, line: 607, type: !11, isLocal: false, isDefinition: true)
!71 = !DIGlobalVariableExpression(var: !72, expr: !DIExpression())
!72 = distinct !DIGlobalVariable(name: "more_tracks_to_read", scope: !2, file: !32, line: 608, type: !11, isLocal: false, isDefinition: true)
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(name: "retry_count", scope: !2, file: !32, line: 609, type: !11, isLocal: false, isDefinition: true)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(name: "dma_transfer_address", scope: !2, file: !32, line: 610, type: !5, isLocal: false, isDefinition: true)
!77 = !DIGlobalVariableExpression(var: !78, expr: !DIExpression())
!78 = distinct !DIGlobalVariable(name: "dma_transfer_size", scope: !2, file: !32, line: 611, type: !5, isLocal: false, isDefinition: true)
!79 = !DIGlobalVariableExpression(var: !80, expr: !DIExpression())
!80 = distinct !DIGlobalVariable(name: "bytes_left_to_read", scope: !2, file: !32, line: 612, type: !5, isLocal: false, isDefinition: true)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "error_saved", scope: !2, file: !32, line: 613, type: !11, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(scope: null, file: !32, line: 683, type: !85, isLocal: true, isDefinition: true)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 160, elements: !86)
!86 = !{!87}
!87 = !DISubrange(count: 20)
!88 = !DIGlobalVariableExpression(var: !89, expr: !DIExpression())
!89 = distinct !DIGlobalVariable(scope: null, file: !32, line: 750, type: !90, isLocal: true, isDefinition: true)
!90 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 248, elements: !91)
!91 = !{!92}
!92 = !DISubrange(count: 31)
!93 = !DIGlobalVariableExpression(var: !94, expr: !DIExpression())
!94 = distinct !DIGlobalVariable(name: "code_end", scope: !2, file: !32, line: 1022, type: !16, isLocal: false, isDefinition: true)
!95 = !DIGlobalVariableExpression(var: !96, expr: !DIExpression())
!96 = distinct !DIGlobalVariable(name: "saved_fdc_command", scope: !2, file: !32, line: 523, type: !11, isLocal: true, isDefinition: true)
!97 = !DIGlobalVariableExpression(var: !98, expr: !DIExpression())
!98 = distinct !DIGlobalVariable(name: "msg_rc702", scope: !2, file: !32, line: 615, type: !99, isLocal: true, isDefinition: true)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !100, size: 56, elements: !101)
!100 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!101 = !{!102}
!102 = !DISubrange(count: 7)
!103 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression())
!104 = distinct !DIGlobalVariable(name: "is_double_sided", scope: !2, file: !32, line: 606, type: !11, isLocal: true, isDefinition: true)
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression())
!106 = distinct !DIGlobalVariable(name: "sem702_font", scope: !2, file: !107, line: 15, type: !108, isLocal: true, isDefinition: true)
!107 = !DIFile(filename: "scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/clang/sem702_font.h", directory: "/Users/ravn/z80", checksumkind: CSK_MD5, checksum: "15283992682122aeebdc9a65ccba5452")
!108 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 11264, elements: !109)
!109 = !{!110}
!110 = !DISubrange(count: 1408)
!111 = !DIGlobalVariableExpression(var: !112, expr: !DIExpression())
!112 = distinct !DIGlobalVariable(name: "qr_screen", scope: !2, file: !113, line: 8, type: !114, isLocal: true, isDefinition: true)
!113 = !DIFile(filename: "scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/clang/qr_data.h", directory: "/Users/ravn/z80", checksumkind: CSK_MD5, checksum: "1658d92757ffdf7d7748505b99a354e0")
!114 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 936, elements: !115)
!115 = !{!116}
!116 = !DISubrange(count: 117)
!117 = !DIGlobalVariableExpression(var: !118, expr: !DIExpression())
!118 = distinct !DIGlobalVariable(scope: null, file: !32, line: 698, type: !119, isLocal: true, isDefinition: true)
!119 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 56, elements: !101)
!120 = !DIGlobalVariableExpression(var: !121, expr: !DIExpression())
!121 = distinct !DIGlobalVariable(scope: null, file: !32, line: 705, type: !122, isLocal: true, isDefinition: true)
!122 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 40, elements: !123)
!123 = !{!124}
!124 = !DISubrange(count: 5)
!125 = !DIGlobalVariableExpression(var: !126, expr: !DIExpression())
!126 = distinct !DIGlobalVariable(scope: null, file: !32, line: 708, type: !122, isLocal: true, isDefinition: true)
!127 = !DIGlobalVariableExpression(var: !128, expr: !DIExpression())
!128 = distinct !DIGlobalVariable(scope: null, file: !32, line: 714, type: !129, isLocal: true, isDefinition: true)
!129 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 176, elements: !130)
!130 = !{!131}
!131 = !DISubrange(count: 22)
!132 = !DIGlobalVariableExpression(var: !133, expr: !DIExpression())
!133 = distinct !DIGlobalVariable(scope: null, file: !32, line: 730, type: !134, isLocal: true, isDefinition: true)
!134 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 136, elements: !135)
!135 = !{!136}
!136 = !DISubrange(count: 17)
!137 = !DIGlobalVariableExpression(var: !138, expr: !DIExpression())
!138 = distinct !DIGlobalVariable(name: "boot_dir", scope: !2, file: !32, line: 695, type: !10, isLocal: true, isDefinition: true)
!139 = !DICompositeType(tag: DW_TAG_array_type, baseType: !140, size: 256, elements: !146)
!140 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !141)
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "format_entry", file: !32, line: 333, baseType: !142)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !32, line: 330, size: 16, elements: !143)
!143 = !{!144, !145}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "eot", scope: !142, file: !32, line: 331, baseType: !11, size: 8)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "gap3", scope: !142, file: !32, line: 332, baseType: !11, size: 8, offset: 8)
!146 = !{!147, !148, !147}
!147 = !DISubrange(count: 2)
!148 = !DISubrange(count: 4)
!149 = !DIGlobalVariableExpression(var: !104, expr: !DIExpression(DW_OP_deref_size, 1, DW_OP_constu, 1, DW_OP_mul, DW_OP_constu, 0, DW_OP_plus, DW_OP_stack_value))
!150 = !DIGlobalVariableExpression(var: !151, expr: !DIExpression())
!151 = distinct !DIGlobalVariable(name: "prefix", scope: !152, file: !32, line: 248, type: !157, isLocal: true, isDefinition: true)
!152 = distinct !DISubprogram(name: "display_sw1_status", scope: !32, file: !32, line: 245, type: !18, scopeLine: 245, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !153, keyInstructions: true)
!153 = !{!154, !155, !150, !156}
!154 = !DILocalVariable(name: "sw", scope: !152, file: !32, line: 246, type: !11)
!155 = !DILocalVariable(name: "p", scope: !152, file: !32, line: 247, type: !25)
!156 = !DILocalVariable(name: "i", scope: !152, file: !32, line: 249, type: !11)
!157 = !DICompositeType(tag: DW_TAG_array_type, baseType: !100, size: 120, elements: !158)
!158 = !{!159}
!159 = !DISubrange(count: 15)
!160 = !{i32 7, !"Dwarf Version", i32 5}
!161 = !{i32 2, !"Debug Info Version", i32 3}
!162 = !{i32 1, !"wchar_size", i32 2}
!163 = !{i32 7, !"frame-pointer", i32 2}
!164 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!165 = !{!"clang version 24.0.0git (git@github.com:ravn/llvm-z80.git d6658ad190659796ca1ea316de6f4fd17def8193)"}
!166 = !{!167, !168, i64 0}
!167 = !{!"__libc_errno", !168, i64 0}
!168 = !{!"int", !169, i64 0}
!169 = !{!"omnipotent char", !170, i64 0}
!170 = !{!"Simple C/C++ TBAA"}
!171 = distinct !DISubprogram(name: "fdc_write_when_ready", scope: !32, file: !32, line: 28, type: !172, scopeLine: 28, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !174, keyInstructions: true)
!172 = !DISubroutineType(types: !173)
!173 = !{null, !11}
!174 = !{!175, !176}
!175 = !DILocalVariable(name: "val", arg: 1, scope: !171, file: !32, line: 28, type: !11)
!176 = !DILocalVariable(name: "t", scope: !171, file: !32, line: 29, type: !5)
!177 = !DILocation(line: 0, scope: !171)
!178 = !DILocation(line: 30, column: 5, scope: !171)
!179 = !DILocation(line: 165, column: 1, scope: !180, inlinedAt: !183, atomGroup: 1, atomRank: 2)
!180 = distinct !DISubprogram(name: "port_in_fdc_status", scope: !6, file: !6, line: 165, type: !181, scopeLine: 165, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!181 = !DISubroutineType(types: !182)
!182 = !{!12}
!183 = distinct !DILocation(line: 31, column: 14, scope: !184)
!184 = distinct !DILexicalBlock(scope: !185, file: !32, line: 31, column: 13)
!185 = distinct !DILexicalBlock(scope: !171, file: !32, line: 30, column: 8)
!186 = !{!169, !169, i64 0}
!187 = !DILocation(line: 31, column: 41, scope: !184, atomGroup: 2, atomRank: 2)
!188 = !DILocation(line: 31, column: 41, scope: !184, atomGroup: 2, atomRank: 1)
!189 = !DILocalVariable(name: "val", arg: 1, scope: !190, file: !6, line: 166, type: !12)
!190 = distinct !DISubprogram(name: "port_out_fdc_data", scope: !6, file: !6, line: 166, type: !191, scopeLine: 166, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !193, keyInstructions: true)
!191 = !DISubroutineType(types: !192)
!192 = !{null, !12}
!193 = !{!189}
!194 = !DILocation(line: 0, scope: !190, inlinedAt: !195)
!195 = distinct !DILocation(line: 32, column: 13, scope: !196)
!196 = distinct !DILexicalBlock(scope: !184, file: !32, line: 31, column: 56)
!197 = !DILocation(line: 166, column: 1, scope: !190, inlinedAt: !195, atomGroup: 1, atomRank: 1)
!198 = !DILocation(line: 33, column: 13, scope: !196, atomGroup: 3, atomRank: 1)
!199 = !DILocation(line: 35, column: 14, scope: !171, atomGroup: 4, atomRank: 2)
!200 = !DILocation(line: 35, column: 5, scope: !185, atomGroup: 5, atomRank: 1)
!201 = !DILocation(line: 35, column: 5, scope: !185, atomGroup: 6, atomRank: 1)
!202 = distinct !{!202, !178, !203, !204}
!203 = !DILocation(line: 35, column: 17, scope: !171)
!204 = !{!"llvm.loop.mustprogress"}
!205 = !DILocation(line: 36, column: 1, scope: !171, atomGroup: 7, atomRank: 1)
!206 = distinct !DISubprogram(name: "fdc_read_when_ready", scope: !32, file: !32, line: 42, type: !207, scopeLine: 42, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !209, keyInstructions: true)
!207 = !DISubroutineType(types: !208)
!208 = !{!11}
!209 = !{!210}
!210 = !DILocalVariable(name: "t", scope: !206, file: !32, line: 43, type: !5)
!211 = !DILocation(line: 0, scope: !206)
!212 = !DILocation(line: 44, column: 5, scope: !206)
!213 = !DILocation(line: 165, column: 1, scope: !180, inlinedAt: !214, atomGroup: 1, atomRank: 2)
!214 = distinct !DILocation(line: 45, column: 14, scope: !215)
!215 = distinct !DILexicalBlock(scope: !216, file: !32, line: 45, column: 13)
!216 = distinct !DILexicalBlock(scope: !206, file: !32, line: 44, column: 8)
!217 = !DILocation(line: 45, column: 41, scope: !215, atomGroup: 2, atomRank: 2)
!218 = !DILocation(line: 45, column: 41, scope: !215, atomGroup: 2, atomRank: 1)
!219 = !DILocation(line: 166, column: 1, scope: !220, inlinedAt: !221, atomGroup: 1, atomRank: 2)
!220 = distinct !DISubprogram(name: "port_in_fdc_data", scope: !6, file: !6, line: 166, type: !181, scopeLine: 166, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!221 = distinct !DILocation(line: 46, column: 20, scope: !222)
!222 = distinct !DILexicalBlock(scope: !215, file: !32, line: 45, column: 56)
!223 = !DILocation(line: 46, column: 13, scope: !222, atomGroup: 3, atomRank: 1)
!224 = !DILocation(line: 48, column: 14, scope: !206, atomGroup: 4, atomRank: 2)
!225 = !DILocation(line: 48, column: 5, scope: !216, atomGroup: 5, atomRank: 1)
!226 = !DILocation(line: 48, column: 5, scope: !216, atomGroup: 6, atomRank: 1)
!227 = distinct !{!227, !212, !228, !204}
!228 = !DILocation(line: 48, column: 17, scope: !206)
!229 = !DILocation(line: 50, column: 1, scope: !206, atomGroup: 8, atomRank: 1)
!230 = distinct !DISubprogram(name: "delay", scope: !32, file: !32, line: 104, type: !231, scopeLine: 104, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !233, keyInstructions: true)
!231 = !DISubroutineType(types: !232)
!232 = !{null, !11, !11}
!233 = !{!234, !235, !236, !238}
!234 = !DILocalVariable(name: "outer", arg: 1, scope: !230, file: !32, line: 104, type: !11)
!235 = !DILocalVariable(name: "inner", arg: 2, scope: !230, file: !32, line: 104, type: !11)
!236 = !DILocalVariable(name: "mid", scope: !237, file: !32, line: 107, type: !11)
!237 = distinct !DILexicalBlock(scope: !230, file: !32, line: 106, column: 8)
!238 = !DILocalVariable(name: "k", scope: !239, file: !32, line: 109, type: !11)
!239 = distinct !DILexicalBlock(scope: !237, file: !32, line: 108, column: 12)
!240 = !DILocation(line: 0, scope: !230)
!241 = !DILocation(line: 105, column: 10, scope: !242, atomGroup: 1, atomRank: 2)
!242 = distinct !DILexicalBlock(scope: !230, file: !32, line: 105, column: 9)
!243 = !DILocation(line: 105, column: 9, scope: !242, atomGroup: 1, atomRank: 1)
!244 = !DILocation(line: 0, scope: !237)
!245 = !DILocation(line: 108, column: 9, scope: !237)
!246 = !DILocation(line: 0, scope: !239)
!247 = !DILocation(line: 110, column: 13, scope: !239)
!248 = !DILocation(line: 111, column: 17, scope: !249, atomGroup: 5, atomRank: 1)
!249 = distinct !DILexicalBlock(scope: !239, file: !32, line: 110, column: 16)
!250 = !{i64 3861}
!251 = !DILocation(line: 112, column: 22, scope: !239, atomGroup: 6, atomRank: 2)
!252 = !DILocation(line: 112, column: 13, scope: !249, atomGroup: 7, atomRank: 1)
!253 = !DILocation(line: 112, column: 13, scope: !249, atomGroup: 8, atomRank: 1)
!254 = distinct !{!254, !247, !255, !204}
!255 = !DILocation(line: 112, column: 25, scope: !239)
!256 = !DILocation(line: 113, column: 18, scope: !237, atomGroup: 9, atomRank: 2)
!257 = !DILocation(line: 113, column: 9, scope: !239, atomGroup: 10, atomRank: 1)
!258 = !DILocation(line: 113, column: 9, scope: !239, atomGroup: 11, atomRank: 1)
!259 = distinct !{!259, !245, !260, !204}
!260 = !DILocation(line: 113, column: 23, scope: !237)
!261 = !DILocation(line: 114, column: 14, scope: !230, atomGroup: 12, atomRank: 2)
!262 = !DILocation(line: 114, column: 5, scope: !237, atomGroup: 13, atomRank: 1)
!263 = !DILocation(line: 114, column: 5, scope: !237, atomGroup: 14, atomRank: 1)
!264 = distinct !{!264, !265, !266, !204}
!265 = !DILocation(line: 106, column: 5, scope: !230)
!266 = !DILocation(line: 114, column: 21, scope: !230)
!267 = !DILocation(line: 115, column: 1, scope: !230, atomGroup: 15, atomRank: 1)
!268 = distinct !DISubprogram(name: "lookup_sectors_and_gap3_for_current_track", scope: !32, file: !32, line: 354, type: !18, scopeLine: 354, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !269, keyInstructions: true)
!269 = !{!270}
!270 = !DILocalVariable(name: "fmt", scope: !268, file: !32, line: 355, type: !271)
!271 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 16)
!272 = !DILocation(line: 355, column: 47, scope: !268)
!273 = !DILocation(line: 355, column: 32, scope: !268)
!274 = !DILocation(line: 355, column: 64, scope: !268)
!275 = !{!276, !169, i64 3}
!276 = !{!"", !169, i64 0, !169, i64 1, !169, i64 2, !169, i64 3, !169, i64 4, !169, i64 5, !169, i64 6}
!277 = !DILocation(line: 355, column: 76, scope: !268)
!278 = !DILocation(line: 355, column: 32, scope: !268, atomGroup: 1, atomRank: 2)
!279 = !DILocation(line: 0, scope: !268)
!280 = !DILocation(line: 357, column: 24, scope: !268, atomGroup: 2, atomRank: 2)
!281 = !{!282, !169, i64 0}
!282 = !{!"", !169, i64 0, !169, i64 1}
!283 = !DILocation(line: 357, column: 17, scope: !268, atomGroup: 2, atomRank: 1)
!284 = !{!276, !169, i64 4}
!285 = !DILocation(line: 358, column: 25, scope: !268)
!286 = !DILocation(line: 358, column: 25, scope: !268, atomGroup: 3, atomRank: 2)
!287 = !{!282, !169, i64 1}
!288 = !DILocation(line: 358, column: 18, scope: !268, atomGroup: 3, atomRank: 1)
!289 = !{!276, !169, i64 5}
!290 = !DILocation(line: 359, column: 17, scope: !268, atomGroup: 4, atomRank: 1)
!291 = !{!276, !169, i64 6}
!292 = !DILocation(line: 360, column: 1, scope: !268, atomGroup: 5, atomRank: 1)
!293 = distinct !DISubprogram(name: "calc_size_of_current_track", scope: !32, file: !32, line: 364, type: !18, scopeLine: 364, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !294, keyInstructions: true)
!294 = !{!295, !296, !297}
!295 = !DILocalVariable(name: "sectors", scope: !293, file: !32, line: 365, type: !11)
!296 = !DILocalVariable(name: "tb", scope: !293, file: !32, line: 369, type: !5)
!297 = !DILocalVariable(name: "i", scope: !298, file: !32, line: 370, type: !11)
!298 = distinct !DILexicalBlock(scope: !293, file: !32, line: 370, column: 5)
!299 = !DILocation(line: 365, column: 22, scope: !293)
!300 = !DILocation(line: 365, column: 32, scope: !293, atomGroup: 2, atomRank: 2)
!301 = !DILocation(line: 365, column: 46, scope: !293, atomGroup: 2, atomRank: 1)
!302 = !DILocation(line: 365, column: 57, scope: !293)
!303 = !{!276, !169, i64 1}
!304 = !DILocation(line: 365, column: 62, scope: !293, atomGroup: 3, atomRank: 2)
!305 = !DILocation(line: 365, column: 20, scope: !293, atomGroup: 3, atomRank: 1)
!306 = !DILocation(line: 367, column: 34, scope: !293)
!307 = !DILocation(line: 367, column: 48, scope: !293)
!308 = !{!276, !169, i64 2}
!309 = !DILocation(line: 367, column: 38, scope: !293)
!310 = !DILocation(line: 367, column: 55, scope: !293)
!311 = !DILocation(line: 369, column: 15, scope: !293, atomGroup: 4, atomRank: 2)
!312 = !DILocation(line: 365, column: 20, scope: !293)
!313 = !DILocation(line: 365, column: 20, scope: !293, atomGroup: 1, atomRank: 3)
!314 = !DILocation(line: 0, scope: !293)
!315 = !DILocation(line: 370, column: 31, scope: !298)
!316 = !DILocation(line: 370, column: 21, scope: !298, atomGroup: 5, atomRank: 3)
!317 = !DILocation(line: 0, scope: !298)
!318 = !DILocation(line: 370, column: 10, scope: !298)
!319 = !DILocation(line: 370, scope: !298, atomGroup: 5, atomRank: 1)
!320 = !DILocation(line: 370, column: 45, scope: !321, atomGroup: 6, atomRank: 1)
!321 = distinct !DILexicalBlock(scope: !298, file: !32, line: 370, column: 5)
!322 = !DILocation(line: 370, column: 5, scope: !298, atomGroup: 7, atomRank: 1)
!323 = !DILocation(line: 373, column: 23, scope: !293, atomGroup: 11, atomRank: 1)
!324 = !{!168, !168, i64 0}
!325 = !DILocation(line: 374, column: 1, scope: !293, atomGroup: 12, atomRank: 1)
!326 = !DILocation(line: 371, column: 12, scope: !327, atomGroup: 8, atomRank: 2)
!327 = distinct !DILexicalBlock(scope: !321, file: !32, line: 370, column: 56)
!328 = !DILocation(line: 370, column: 52, scope: !321, atomGroup: 9, atomRank: 2)
!329 = !DILocation(line: 370, column: 5, scope: !321)
!330 = distinct !{!330, !331, !332, !204}
!331 = !DILocation(line: 370, column: 5, scope: !298)
!332 = !DILocation(line: 372, column: 5, scope: !298)
!333 = distinct !DISubprogram(name: "fdc_sense_interrupt", scope: !32, file: !32, line: 411, type: !18, scopeLine: 411, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!334 = !DILocation(line: 412, column: 5, scope: !333)
!335 = !DILocation(line: 413, column: 22, scope: !333, atomGroup: 1, atomRank: 2)
!336 = !DILocation(line: 413, column: 20, scope: !333, atomGroup: 1, atomRank: 1)
!337 = !{!338, !169, i64 0}
!338 = !{!"", !169, i64 0, !169, i64 1, !169, i64 2, !169, i64 3, !169, i64 4, !169, i64 5, !169, i64 6, !169, i64 7}
!339 = !DILocation(line: 414, column: 39, scope: !340, atomGroup: 2, atomRank: 2)
!340 = distinct !DILexicalBlock(scope: !333, file: !32, line: 414, column: 9)
!341 = !DILocation(line: 414, column: 39, scope: !340, atomGroup: 2, atomRank: 1)
!342 = !DILocation(line: 416, column: 26, scope: !343, atomGroup: 3, atomRank: 2)
!343 = distinct !DILexicalBlock(scope: !340, file: !32, line: 414, column: 54)
!344 = !DILocation(line: 416, column: 24, scope: !343, atomGroup: 3, atomRank: 1)
!345 = !{!338, !169, i64 1}
!346 = !DILocation(line: 417, column: 5, scope: !343)
!347 = !DILocation(line: 418, column: 1, scope: !333, atomGroup: 4, atomRank: 1)
!348 = distinct !DISubprogram(name: "fdc_read_result", scope: !32, file: !32, line: 428, type: !18, scopeLine: 428, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !349, keyInstructions: true)
!349 = !{!350, !351}
!350 = !DILocalVariable(name: "i", scope: !348, file: !32, line: 429, type: !11)
!351 = !DILocalVariable(name: "p", scope: !348, file: !32, line: 430, type: !10)
!352 = !DILocation(line: 0, scope: !348)
!353 = !DILocation(line: 432, column: 10, scope: !354)
!354 = distinct !DILexicalBlock(scope: !348, file: !32, line: 432, column: 5)
!355 = !DILocation(line: 432, scope: !354, atomGroup: 2, atomRank: 1)
!356 = !DILocation(line: 432, column: 19, scope: !357, atomGroup: 3, atomRank: 1)
!357 = distinct !DILexicalBlock(scope: !354, file: !32, line: 432, column: 5)
!358 = !DILocation(line: 432, column: 5, scope: !354, atomGroup: 4, atomRank: 1)
!359 = !DILocation(line: 433, column: 16, scope: !360, atomGroup: 5, atomRank: 2)
!360 = distinct !DILexicalBlock(scope: !357, file: !32, line: 432, column: 29)
!361 = !DILocation(line: 433, column: 9, scope: !360)
!362 = !DILocation(line: 433, column: 14, scope: !360, atomGroup: 5, atomRank: 1)
!363 = !DILocation(line: 165, column: 1, scope: !180, inlinedAt: !364, atomGroup: 1, atomRank: 2)
!364 = distinct !DILocation(line: 435, column: 15, scope: !365)
!365 = distinct !DILexicalBlock(scope: !360, file: !32, line: 435, column: 13)
!366 = !DILocation(line: 435, column: 28, scope: !365)
!367 = !DILocation(line: 435, column: 28, scope: !365, atomGroup: 6, atomRank: 2)
!368 = !DILocation(line: 432, column: 25, scope: !357, atomGroup: 9, atomRank: 2)
!369 = !DILocation(line: 435, column: 13, scope: !365, atomGroup: 6, atomRank: 1)
!370 = distinct !{!370, !371, !372, !204}
!371 = !DILocation(line: 432, column: 5, scope: !354)
!372 = !DILocation(line: 440, column: 5, scope: !354)
!373 = !DILocation(line: 196, column: 1, scope: !374, inlinedAt: !375, atomGroup: 1, atomRank: 2)
!374 = distinct !DISubprogram(name: "port_in_dma_cmd", scope: !6, file: !6, line: 196, type: !181, scopeLine: 196, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!375 = distinct !DILocation(line: 437, column: 24, scope: !376)
!376 = distinct !DILexicalBlock(scope: !365, file: !32, line: 435, column: 43)
!377 = !DILocation(line: 437, column: 13, scope: !376)
!378 = !DILocation(line: 437, column: 22, scope: !376, atomGroup: 7, atomRank: 1)
!379 = !DILocation(line: 438, column: 13, scope: !376, atomGroup: 8, atomRank: 1)
!380 = !DILocation(line: 441, column: 17, scope: !348, atomGroup: 11, atomRank: 1)
!381 = !DILocation(line: 442, column: 5, scope: !348)
!382 = !DILocation(line: 443, column: 1, scope: !348)
!383 = !DILocation(line: 443, column: 1, scope: !348, atomGroup: 12, atomRank: 1)
!384 = distinct !DISubprogram(name: "error_display_halt", scope: !32, file: !32, line: 676, type: !172, scopeLine: 676, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !385, keyInstructions: true)
!385 = !{!386}
!386 = !DILocalVariable(name: "code", arg: 1, scope: !384, file: !32, line: 676, type: !11)
!387 = !DILocation(line: 0, scope: !384)
!388 = !DILocation(line: 677, column: 17, scope: !384, atomGroup: 1, atomRank: 1)
!389 = !DILocation(line: 16, column: 5, scope: !390, inlinedAt: !392, atomGroup: 1, atomRank: 1)
!390 = distinct !DISubprogram(name: "intrinsic_ei", scope: !391, file: !391, line: 15, type: !18, scopeLine: 15, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!391 = !DIFile(filename: "scratch/pre-pr40-firmware-archive/reproductions/autoload-c863c55/current-d6658ad-asio/always-inline-probe/clang/intrinsic.h", directory: "/Users/ravn/z80", checksumkind: CSK_MD5, checksum: "8ca9d18cd61424311921567aa4e05c25")
!392 = distinct !DILocation(line: 678, column: 5, scope: !384)
!393 = !{i64 119301}
!394 = !DILocation(line: 679, column: 9, scope: !395)
!395 = distinct !DILexicalBlock(scope: !384, file: !32, line: 679, column: 9)
!396 = !DILocation(line: 679, column: 19, scope: !395)
!397 = !DILocation(line: 679, column: 19, scope: !395, atomGroup: 2, atomRank: 2)
!398 = !DILocation(line: 679, column: 19, scope: !395, atomGroup: 2, atomRank: 1)
!399 = !DILocalVariable(name: "val", arg: 1, scope: !400, file: !6, line: 186, type: !12)
!400 = distinct !DISubprogram(name: "port_out_bib", scope: !6, file: !6, line: 186, type: !191, scopeLine: 186, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !401, keyInstructions: true)
!401 = !{!399}
!402 = !DILocation(line: 0, scope: !400, inlinedAt: !403)
!403 = distinct !DILocation(line: 682, column: 5, scope: !384)
!404 = !DILocation(line: 186, column: 1, scope: !400, inlinedAt: !403, atomGroup: 1, atomRank: 1)
!405 = !DILocation(line: 683, column: 5, scope: !406, atomGroup: 4, atomRank: 1)
!406 = distinct !DILexicalBlock(scope: !384, file: !32, line: 683, column: 5)
!407 = !DILocation(line: 683, column: 5, scope: !406)
!408 = !DILocation(line: 684, column: 1, scope: !384, atomGroup: 5, atomRank: 1)
!409 = distinct !DISubprogram(name: "wait_fdc_ready", scope: !32, file: !32, line: 447, type: !410, scopeLine: 447, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !412, keyInstructions: true)
!410 = !DISubroutineType(types: !411)
!411 = !{!11, !11}
!412 = !{!413}
!413 = !DILocalVariable(name: "timeout", arg: 1, scope: !409, file: !32, line: 447, type: !11)
!414 = !DILocation(line: 0, scope: !409)
!415 = !DILocation(line: 448, column: 5, scope: !409)
!416 = !DILocation(line: 448, column: 12, scope: !409, atomGroup: 1, atomRank: 2)
!417 = !DILocation(line: 448, column: 5, scope: !409, atomGroup: 2, atomRank: 1)
!418 = !DILocation(line: 448, column: 5, scope: !409, atomGroup: 3, atomRank: 1)
!419 = !DILocation(line: 449, column: 9, scope: !420)
!420 = distinct !DILexicalBlock(scope: !409, file: !32, line: 448, column: 23)
!421 = !DILocation(line: 450, column: 13, scope: !422)
!422 = distinct !DILexicalBlock(scope: !420, file: !32, line: 450, column: 13)
!423 = !DILocation(line: 450, column: 13, scope: !422, atomGroup: 4, atomRank: 2)
!424 = !DILocation(line: 450, column: 13, scope: !422, atomGroup: 4, atomRank: 1)
!425 = distinct !{!425, !415, !426, !204}
!426 = !DILocation(line: 456, column: 5, scope: !409)
!427 = !DILocation(line: 12, column: 5, scope: !428, inlinedAt: !429, atomGroup: 1, atomRank: 1)
!428 = distinct !DISubprogram(name: "intrinsic_di", scope: !391, file: !391, line: 11, type: !18, scopeLine: 11, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!429 = distinct !DILocation(line: 451, column: 13, scope: !430)
!430 = distinct !DILexicalBlock(scope: !422, file: !32, line: 450, column: 46)
!431 = !{i64 119230}
!432 = !DILocation(line: 452, column: 45, scope: !430, atomGroup: 5, atomRank: 1)
!433 = !DILocation(line: 16, column: 5, scope: !390, inlinedAt: !434, atomGroup: 1, atomRank: 1)
!434 = distinct !DILocation(line: 453, column: 13, scope: !430)
!435 = !DILocation(line: 454, column: 13, scope: !430, atomGroup: 6, atomRank: 1)
!436 = !DILocation(line: 459, column: 1, scope: !409, atomGroup: 8, atomRank: 1)
!437 = distinct !DISubprogram(name: "fdc_select_drive_cylinder_head", scope: !32, file: !32, line: 470, type: !207, scopeLine: 470, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!438 = !DILocation(line: 471, column: 30, scope: !437)
!439 = !DILocation(line: 471, column: 35, scope: !437)
!440 = !DILocation(line: 471, column: 43, scope: !437)
!441 = !DILocation(line: 471, column: 41, scope: !437)
!442 = !DILocation(line: 471, column: 66, scope: !437)
!443 = !{!276, !169, i64 0}
!444 = !DILocalVariable(name: "head_and_drive", arg: 1, scope: !445, file: !32, line: 421, type: !11)
!445 = distinct !DISubprogram(name: "fdc_seek", scope: !32, file: !32, line: 421, type: !231, scopeLine: 421, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !446, keyInstructions: true)
!446 = !{!444, !447}
!447 = !DILocalVariable(name: "cylinder", arg: 2, scope: !445, file: !32, line: 421, type: !11)
!448 = !DILocation(line: 0, scope: !445, inlinedAt: !449)
!449 = distinct !DILocation(line: 471, column: 5, scope: !437)
!450 = !DILocation(line: 422, column: 5, scope: !445, inlinedAt: !449)
!451 = !DILocation(line: 423, column: 41, scope: !445, inlinedAt: !449)
!452 = !DILocation(line: 423, column: 5, scope: !445, inlinedAt: !449)
!453 = !DILocation(line: 424, column: 5, scope: !445, inlinedAt: !449)
!454 = !DILocation(line: 472, column: 39, scope: !437)
!455 = !DILocation(line: 472, column: 12, scope: !437, atomGroup: 1, atomRank: 2)
!456 = !DILocation(line: 472, column: 5, scope: !437, atomGroup: 1, atomRank: 1)
!457 = distinct !DISubprogram(name: "verify_seek_result", scope: !32, file: !32, line: 477, type: !410, scopeLine: 477, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !458, keyInstructions: true)
!458 = !{!459}
!459 = !DILocalVariable(name: "expected_pcn", arg: 1, scope: !457, file: !32, line: 477, type: !11)
!460 = !DILocation(line: 0, scope: !457)
!461 = !DILocation(line: 478, column: 9, scope: !462)
!462 = distinct !DILexicalBlock(scope: !457, file: !32, line: 478, column: 9)
!463 = !DILocation(line: 478, column: 9, scope: !462, atomGroup: 1, atomRank: 2)
!464 = !DILocation(line: 478, column: 9, scope: !462, atomGroup: 1, atomRank: 1)
!465 = !DILocation(line: 481, column: 10, scope: !466)
!466 = distinct !DILexicalBlock(scope: !457, file: !32, line: 481, column: 9)
!467 = !DILocation(line: 481, column: 23, scope: !466)
!468 = !DILocation(line: 481, column: 51, scope: !466)
!469 = !DILocation(line: 481, column: 40, scope: !466)
!470 = !DILocation(line: 481, column: 37, scope: !466, atomGroup: 3, atomRank: 2)
!471 = !DILocation(line: 481, column: 55, scope: !466, atomGroup: 3, atomRank: 1)
!472 = !DILocation(line: 482, column: 36, scope: !466)
!473 = !DILocation(line: 482, column: 22, scope: !466, atomGroup: 4, atomRank: 2)
!474 = !DILocation(line: 481, column: 55, scope: !466, atomGroup: 4, atomRank: 1)
!475 = !DILocation(line: 486, column: 5, scope: !457, atomGroup: 6, atomRank: 1)
!476 = !DILocation(line: 487, column: 1, scope: !457, atomGroup: 7, atomRank: 1)
!477 = distinct !DISubprogram(name: "fdc_write_full_cmd", scope: !32, file: !32, line: 491, type: !172, scopeLine: 491, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !478, keyInstructions: true)
!478 = !{!479, !480, !481, !482}
!479 = !DILocalVariable(name: "cmd", arg: 1, scope: !477, file: !32, line: 491, type: !11)
!480 = !DILocalVariable(name: "mfm_flag", scope: !477, file: !32, line: 492, type: !11)
!481 = !DILocalVariable(name: "dh", scope: !477, file: !32, line: 493, type: !11)
!482 = !DILocalVariable(name: "i", scope: !483, file: !32, line: 501, type: !11)
!483 = distinct !DILexicalBlock(scope: !484, file: !32, line: 499, column: 46)
!484 = distinct !DILexicalBlock(scope: !477, file: !32, line: 499, column: 9)
!485 = !DILocation(line: 0, scope: !477)
!486 = !DILocation(line: 492, column: 21, scope: !477)
!487 = !DILocation(line: 492, column: 21, scope: !477, atomGroup: 1, atomRank: 3)
!488 = !DILocation(line: 493, column: 31, scope: !477)
!489 = !DILocation(line: 493, column: 36, scope: !477)
!490 = !DILocation(line: 493, column: 44, scope: !477)
!491 = !DILocation(line: 493, column: 42, scope: !477, atomGroup: 2, atomRank: 3)
!492 = !DILocation(line: 12, column: 5, scope: !428, inlinedAt: !493, atomGroup: 1, atomRank: 1)
!493 = distinct !DILocation(line: 495, column: 5, scope: !477)
!494 = !DILocation(line: 496, column: 30, scope: !477)
!495 = !DILocation(line: 496, column: 5, scope: !477)
!496 = !DILocation(line: 497, column: 5, scope: !477)
!497 = !DILocation(line: 499, column: 14, scope: !484)
!498 = !DILocation(line: 499, column: 28, scope: !484, atomGroup: 3, atomRank: 2)
!499 = !DILocation(line: 499, column: 28, scope: !484, atomGroup: 3, atomRank: 1)
!500 = !DILocation(line: 502, scope: !501, atomGroup: 4, atomRank: 1)
!501 = distinct !DILexicalBlock(scope: !483, file: !32, line: 502, column: 9)
!502 = !DILocation(line: 0, scope: !483)
!503 = !DILocation(line: 502, column: 23, scope: !504, atomGroup: 5, atomRank: 1)
!504 = distinct !DILexicalBlock(scope: !501, file: !32, line: 502, column: 9)
!505 = !DILocation(line: 502, column: 9, scope: !501, atomGroup: 6, atomRank: 1)
!506 = !DILocation(line: 503, column: 34, scope: !507)
!507 = distinct !DILexicalBlock(scope: !504, file: !32, line: 502, column: 47)
!508 = !DILocation(line: 503, column: 13, scope: !507)
!509 = !DILocation(line: 502, column: 43, scope: !504, atomGroup: 7, atomRank: 2)
!510 = !DILocation(line: 502, column: 9, scope: !504)
!511 = distinct !{!511, !512, !513, !204}
!512 = !DILocation(line: 502, column: 9, scope: !501)
!513 = !DILocation(line: 504, column: 9, scope: !501)
!514 = !DILocation(line: 16, column: 5, scope: !390, inlinedAt: !515, atomGroup: 1, atomRank: 1)
!515 = distinct !DILocation(line: 506, column: 5, scope: !477)
!516 = !DILocation(line: 507, column: 1, scope: !477, atomGroup: 9, atomRank: 1)
!517 = distinct !DISubprogram(name: "check_fdc_result", scope: !32, file: !32, line: 510, type: !207, scopeLine: 510, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!518 = !DILocation(line: 511, column: 21, scope: !519)
!519 = distinct !DILexicalBlock(scope: !517, file: !32, line: 511, column: 9)
!520 = !DILocation(line: 511, column: 25, scope: !519)
!521 = !DILocation(line: 511, column: 42, scope: !519)
!522 = !DILocation(line: 511, column: 39, scope: !519, atomGroup: 1, atomRank: 2)
!523 = !DILocation(line: 511, column: 55, scope: !519, atomGroup: 1, atomRank: 1)
!524 = !DILocation(line: 512, column: 20, scope: !519)
!525 = !DILocation(line: 512, column: 24, scope: !519, atomGroup: 2, atomRank: 2)
!526 = !DILocation(line: 512, column: 29, scope: !519, atomGroup: 2, atomRank: 1)
!527 = !DILocation(line: 513, column: 21, scope: !519)
!528 = !{!338, !169, i64 2}
!529 = !DILocation(line: 513, column: 25, scope: !519)
!530 = !DILocation(line: 513, column: 39, scope: !519, atomGroup: 3, atomRank: 2)
!531 = !DILocation(line: 512, column: 29, scope: !519, atomGroup: 3, atomRank: 1)
!532 = !DILocation(line: 517, column: 20, scope: !533)
!533 = distinct !DILexicalBlock(scope: !519, file: !32, line: 516, column: 12)
!534 = !DILocation(line: 517, column: 20, scope: !533, atomGroup: 5, atomRank: 2)
!535 = !DILocation(line: 517, column: 20, scope: !533, atomGroup: 5, atomRank: 1)
!536 = !DILocation(line: 518, column: 29, scope: !533)
!537 = !DILocation(line: 518, column: 16, scope: !533, atomGroup: 6, atomRank: 3)
!538 = !DILocation(line: 518, column: 9, scope: !533, atomGroup: 6, atomRank: 1)
!539 = !DILocation(line: 0, scope: !519)
!540 = !DILocation(line: 520, column: 1, scope: !517, atomGroup: 7, atomRank: 1)
!541 = distinct !DISubprogram(name: "fdc_get_result_bytes", scope: !32, file: !32, line: 526, type: !542, scopeLine: 526, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !544, keyInstructions: true)
!542 = !DISubroutineType(types: !543)
!543 = !{!11, !11, !11}
!544 = !{!545, !546, !547, !548, !553}
!545 = !DILocalVariable(name: "cmd", arg: 1, scope: !541, file: !32, line: 526, type: !11)
!546 = !DILocalVariable(name: "retries", arg: 2, scope: !541, file: !32, line: 526, type: !11)
!547 = !DILocalVariable(name: "r", scope: !541, file: !32, line: 527, type: !11)
!548 = !DILocalVariable(name: "_t", scope: !549, file: !32, line: 543, type: !5)
!549 = distinct !DILexicalBlock(scope: !550, file: !32, line: 543, column: 13)
!550 = distinct !DILexicalBlock(scope: !551, file: !32, line: 537, column: 62)
!551 = distinct !DILexicalBlock(scope: !552, file: !32, line: 537, column: 13)
!552 = distinct !DILexicalBlock(scope: !541, file: !32, line: 531, column: 15)
!553 = !DILocalVariable(name: "_t", scope: !554, file: !32, line: 544, type: !5)
!554 = distinct !DILexicalBlock(scope: !550, file: !32, line: 544, column: 13)
!555 = !DILocation(line: 0, scope: !541)
!556 = !DILocation(line: 528, column: 23, scope: !541, atomGroup: 1, atomRank: 1)
!557 = !DILocation(line: 529, column: 17, scope: !541, atomGroup: 2, atomRank: 1)
!558 = !DILocation(line: 531, column: 5, scope: !541)
!559 = !DILocation(line: 12, column: 5, scope: !428, inlinedAt: !560, atomGroup: 1, atomRank: 1)
!560 = distinct !DILocation(line: 533, column: 9, scope: !552)
!561 = !DILocation(line: 534, column: 41, scope: !552, atomGroup: 3, atomRank: 1)
!562 = !DILocation(line: 16, column: 5, scope: !390, inlinedAt: !563, atomGroup: 1, atomRank: 1)
!563 = distinct !DILocation(line: 535, column: 9, scope: !552)
!564 = !DILocation(line: 537, column: 14, scope: !551)
!565 = !DILocation(line: 537, column: 32, scope: !551)
!566 = !DILocation(line: 537, column: 46, scope: !551, atomGroup: 4, atomRank: 2)
!567 = !DILocation(line: 537, column: 46, scope: !551, atomGroup: 4, atomRank: 1)
!568 = !DILocation(line: 12, column: 5, scope: !428, inlinedAt: !569, atomGroup: 1, atomRank: 1)
!569 = distinct !DILocation(line: 539, column: 13, scope: !550)
!570 = !DILocalVariable(name: "val", arg: 1, scope: !571, file: !6, line: 197, type: !12)
!571 = distinct !DISubprogram(name: "port_out_dma_smsk", scope: !6, file: !6, line: 197, type: !191, scopeLine: 197, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !572, keyInstructions: true)
!572 = !{!570}
!573 = !DILocation(line: 0, scope: !571, inlinedAt: !574)
!574 = distinct !DILocation(line: 540, column: 13, scope: !550)
!575 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !574, atomGroup: 1, atomRank: 1)
!576 = !DILocalVariable(name: "val", arg: 1, scope: !577, file: !6, line: 198, type: !12)
!577 = distinct !DISubprogram(name: "port_out_dma_mode", scope: !6, file: !6, line: 198, type: !191, scopeLine: 198, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !578, keyInstructions: true)
!578 = !{!576}
!579 = !DILocation(line: 0, scope: !577, inlinedAt: !580)
!580 = distinct !DILocation(line: 541, column: 13, scope: !550)
!581 = !DILocation(line: 198, column: 1, scope: !577, inlinedAt: !580, atomGroup: 1, atomRank: 1)
!582 = !DILocalVariable(name: "val", arg: 1, scope: !583, file: !6, line: 199, type: !12)
!583 = distinct !DISubprogram(name: "port_out_dma_clbp", scope: !6, file: !6, line: 199, type: !191, scopeLine: 199, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !584, keyInstructions: true)
!584 = !{!582}
!585 = !DILocation(line: 0, scope: !583, inlinedAt: !586)
!586 = distinct !DILocation(line: 542, column: 13, scope: !550)
!587 = !DILocation(line: 199, column: 1, scope: !583, inlinedAt: !586, atomGroup: 1, atomRank: 1)
!588 = !DILocation(line: 543, column: 26, scope: !549, atomGroup: 5, atomRank: 2)
!589 = !DILocation(line: 0, scope: !549)
!590 = !DILocation(line: 543, column: 13, scope: !549)
!591 = !DILocalVariable(name: "val", arg: 1, scope: !592, file: !6, line: 190, type: !12)
!592 = distinct !DISubprogram(name: "port_out_dma_ch1_addr", scope: !6, file: !6, line: 190, type: !191, scopeLine: 190, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !593, keyInstructions: true)
!593 = !{!591}
!594 = !DILocation(line: 0, scope: !592, inlinedAt: !595)
!595 = distinct !DILocation(line: 543, column: 13, scope: !549)
!596 = !DILocation(line: 190, column: 1, scope: !592, inlinedAt: !595, atomGroup: 1, atomRank: 1)
!597 = !DILocation(line: 0, scope: !592, inlinedAt: !598)
!598 = distinct !DILocation(line: 543, column: 13, scope: !549)
!599 = !DILocation(line: 190, column: 1, scope: !592, inlinedAt: !598, atomGroup: 1, atomRank: 1)
!600 = !DILocation(line: 544, column: 24, scope: !554)
!601 = !DILocation(line: 544, column: 42, scope: !554, atomGroup: 6, atomRank: 2)
!602 = !DILocation(line: 0, scope: !554)
!603 = !DILocation(line: 544, column: 13, scope: !554)
!604 = !DILocalVariable(name: "val", arg: 1, scope: !605, file: !6, line: 191, type: !12)
!605 = distinct !DISubprogram(name: "port_out_dma_ch1_wc", scope: !6, file: !6, line: 191, type: !191, scopeLine: 191, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !606, keyInstructions: true)
!606 = !{!604}
!607 = !DILocation(line: 0, scope: !605, inlinedAt: !608)
!608 = distinct !DILocation(line: 544, column: 13, scope: !554)
!609 = !DILocation(line: 191, column: 1, scope: !605, inlinedAt: !608, atomGroup: 1, atomRank: 1)
!610 = !DILocation(line: 0, scope: !605, inlinedAt: !611)
!611 = distinct !DILocation(line: 544, column: 13, scope: !554)
!612 = !DILocation(line: 191, column: 1, scope: !605, inlinedAt: !611, atomGroup: 1, atomRank: 1)
!613 = !DILocation(line: 0, scope: !571, inlinedAt: !614)
!614 = distinct !DILocation(line: 545, column: 13, scope: !550)
!615 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !614, atomGroup: 1, atomRank: 1)
!616 = !DILocation(line: 16, column: 5, scope: !390, inlinedAt: !617, atomGroup: 1, atomRank: 1)
!617 = distinct !DILocation(line: 546, column: 13, scope: !550)
!618 = !DILocation(line: 547, column: 9, scope: !550)
!619 = !DILocation(line: 549, column: 28, scope: !552)
!620 = !DILocation(line: 549, column: 9, scope: !552)
!621 = !DILocation(line: 551, column: 13, scope: !622)
!622 = distinct !DILexicalBlock(scope: !552, file: !32, line: 551, column: 13)
!623 = !DILocation(line: 551, column: 13, scope: !622, atomGroup: 7, atomRank: 2)
!624 = !DILocation(line: 551, column: 13, scope: !622, atomGroup: 7, atomRank: 1)
!625 = !DILocation(line: 555, column: 13, scope: !552, atomGroup: 9, atomRank: 2)
!626 = !DILocation(line: 556, column: 15, scope: !627, atomGroup: 10, atomRank: 1)
!627 = distinct !DILexicalBlock(scope: !552, file: !32, line: 556, column: 13)
!628 = !DILocation(line: 563, column: 1, scope: !541, atomGroup: 14, atomRank: 1)
!629 = !DILocation(line: 0, scope: !552)
!630 = distinct !DISubprogram(name: "fdc_detect_sector_size_and_density", scope: !32, file: !32, line: 567, type: !207, scopeLine: 567, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!631 = !DILocation(line: 570, column: 5, scope: !630)
!632 = !DILocation(line: 0, scope: !630)
!633 = !DILocation(line: 571, column: 13, scope: !634)
!634 = distinct !DILexicalBlock(scope: !635, file: !32, line: 571, column: 13)
!635 = distinct !DILexicalBlock(scope: !630, file: !32, line: 570, column: 15)
!636 = !DILocation(line: 571, column: 46, scope: !634, atomGroup: 2, atomRank: 2)
!637 = !DILocation(line: 571, column: 46, scope: !634, atomGroup: 2, atomRank: 1)
!638 = !DILocation(line: 575, column: 27, scope: !635, atomGroup: 4, atomRank: 1)
!639 = !DILocation(line: 576, column: 13, scope: !640)
!640 = distinct !DILexicalBlock(scope: !635, file: !32, line: 576, column: 13)
!641 = !DILocation(line: 576, column: 50, scope: !640, atomGroup: 5, atomRank: 2)
!642 = !DILocation(line: 576, column: 50, scope: !640, atomGroup: 5, atomRank: 1)
!643 = !DILocation(line: 579, column: 13, scope: !644)
!644 = distinct !DILexicalBlock(scope: !635, file: !32, line: 579, column: 13)
!645 = !DILocation(line: 579, column: 13, scope: !644, atomGroup: 7, atomRank: 2)
!646 = !DILocation(line: 579, column: 13, scope: !644, atomGroup: 7, atomRank: 1)
!647 = !DILocation(line: 585, column: 37, scope: !630)
!648 = !{!338, !169, i64 6}
!649 = !DILocation(line: 585, column: 47, scope: !630, atomGroup: 10, atomRank: 3)
!650 = !DILocation(line: 585, column: 24, scope: !630, atomGroup: 10, atomRank: 1)
!651 = !DILocation(line: 586, column: 5, scope: !630)
!652 = !DILocation(line: 587, column: 5, scope: !630)
!653 = !DILocation(line: 588, column: 5, scope: !630, atomGroup: 11, atomRank: 1)
!654 = !DILocation(line: 589, column: 1, scope: !630, atomGroup: 12, atomRank: 1)
!655 = distinct !DISubprogram(name: "halt_forever", scope: !32, file: !32, line: 622, type: !18, scopeLine: 622, flags: DIFlagPrototyped | DIFlagNoReturn | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!656 = !DILocalVariable(name: "val", arg: 1, scope: !657, file: !6, line: 170, type: !12)
!657 = distinct !DISubprogram(name: "port_out_ctc3", scope: !6, file: !6, line: 170, type: !191, scopeLine: 170, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !658, keyInstructions: true)
!658 = !{!656}
!659 = !DILocation(line: 0, scope: !657, inlinedAt: !660)
!660 = distinct !DILocation(line: 623, column: 5, scope: !655)
!661 = !DILocation(line: 170, column: 1, scope: !657, inlinedAt: !660, atomGroup: 1, atomRank: 1)
!662 = !DILocation(line: 0, scope: !571, inlinedAt: !663)
!663 = distinct !DILocation(line: 624, column: 5, scope: !655)
!664 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !663, atomGroup: 1, atomRank: 1)
!665 = !DILocation(line: 16, column: 5, scope: !390, inlinedAt: !666, atomGroup: 1, atomRank: 1)
!666 = distinct !DILocation(line: 625, column: 5, scope: !655)
!667 = !DILocation(line: 626, column: 5, scope: !655)
!668 = !DILocation(line: 626, column: 5, scope: !669, atomGroup: 1, atomRank: 1)
!669 = distinct !DILexicalBlock(scope: !670, file: !32, line: 626, column: 5)
!670 = distinct !DILexicalBlock(scope: !655, file: !32, line: 626, column: 5)
!671 = distinct !{!671, !672, !673}
!672 = !DILocation(line: 626, column: 5, scope: !670)
!673 = !DILocation(line: 626, column: 13, scope: !670)
!674 = distinct !DISubprogram(name: "compare_6bytes", scope: !32, file: !32, line: 647, type: !675, scopeLine: 647, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !677, keyInstructions: true)
!675 = !DISubroutineType(types: !676)
!676 = !{!11, !15, !15}
!677 = !{!678, !679, !680}
!678 = !DILocalVariable(name: "a", arg: 1, scope: !674, file: !32, line: 647, type: !15)
!679 = !DILocalVariable(name: "b", arg: 2, scope: !674, file: !32, line: 647, type: !15)
!680 = !DILocalVariable(name: "i", scope: !674, file: !32, line: 648, type: !11)
!681 = !DILocation(line: 0, scope: !674)
!682 = !DILocation(line: 649, column: 5, scope: !674)
!683 = !DILocation(line: 650, column: 13, scope: !684)
!684 = distinct !DILexicalBlock(scope: !685, file: !32, line: 650, column: 13)
!685 = distinct !DILexicalBlock(scope: !674, file: !32, line: 649, column: 8)
!686 = !DILocation(line: 650, column: 21, scope: !684)
!687 = !DILocation(line: 650, column: 18, scope: !684, atomGroup: 4, atomRank: 2)
!688 = !DILocation(line: 650, column: 18, scope: !684, atomGroup: 4, atomRank: 1)
!689 = !DILocation(line: 650, column: 23, scope: !684, atomGroup: 3, atomRank: 2)
!690 = !DILocation(line: 650, column: 15, scope: !684, atomGroup: 2, atomRank: 2)
!691 = !DILocation(line: 653, column: 14, scope: !674, atomGroup: 6, atomRank: 2)
!692 = !DILocation(line: 653, column: 5, scope: !685, atomGroup: 7, atomRank: 1)
!693 = !DILocation(line: 653, column: 5, scope: !685, atomGroup: 8, atomRank: 1)
!694 = distinct !{!694, !682, !695, !204}
!695 = !DILocation(line: 653, column: 17, scope: !674)
!696 = !DILocation(line: 655, column: 1, scope: !674, atomGroup: 10, atomRank: 1)
!697 = distinct !DISubprogram(name: "check_sysfile", scope: !32, file: !32, line: 658, type: !698, scopeLine: 658, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !701, keyInstructions: true)
!698 = !DISubroutineType(types: !699)
!699 = !{!11, !15, !700}
!700 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 16)
!701 = !{!702, !703, !704}
!702 = !DILocalVariable(name: "dir", arg: 1, scope: !697, file: !32, line: 658, type: !15)
!703 = !DILocalVariable(name: "pattern", arg: 2, scope: !697, file: !32, line: 658, type: !700)
!704 = !DILocalVariable(name: "i", scope: !697, file: !32, line: 661, type: !11)
!705 = !DILocation(line: 0, scope: !697)
!706 = !DILocation(line: 662, column: 5, scope: !697)
!707 = !DILocation(line: 663, column: 13, scope: !708)
!708 = distinct !DILexicalBlock(scope: !709, file: !32, line: 663, column: 13)
!709 = distinct !DILexicalBlock(scope: !697, file: !32, line: 662, column: 8)
!710 = !DILocation(line: 663, column: 23, scope: !708)
!711 = !DILocation(line: 663, column: 20, scope: !708, atomGroup: 5, atomRank: 2)
!712 = !DILocation(line: 663, column: 20, scope: !708, atomGroup: 5, atomRank: 1)
!713 = !DILocation(line: 663, column: 31, scope: !708, atomGroup: 4, atomRank: 2)
!714 = !DILocation(line: 666, column: 14, scope: !697, atomGroup: 7, atomRank: 2)
!715 = !DILocation(line: 666, column: 5, scope: !709, atomGroup: 8, atomRank: 1)
!716 = !DILocation(line: 666, column: 5, scope: !709, atomGroup: 9, atomRank: 1)
!717 = distinct !{!717, !706, !718, !204}
!718 = !DILocation(line: 666, column: 17, scope: !697)
!719 = !DILocation(line: 669, column: 10, scope: !720)
!720 = distinct !DILexicalBlock(scope: !697, file: !32, line: 669, column: 9)
!721 = !DILocation(line: 669, column: 17, scope: !720)
!722 = !DILocation(line: 669, column: 31, scope: !720, atomGroup: 10, atomRank: 2)
!723 = !DILocation(line: 673, column: 1, scope: !697, atomGroup: 13, atomRank: 1)
!724 = distinct !DISubprogram(name: "prom1_if_present", scope: !32, file: !32, line: 744, type: !18, scopeLine: 744, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!725 = !DILocation(line: 175, column: 1, scope: !726, inlinedAt: !727, atomGroup: 1, atomRank: 2)
!726 = distinct !DISubprogram(name: "port_in_sw1", scope: !6, file: !6, line: 175, type: !181, scopeLine: 175, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!727 = distinct !DILocation(line: 745, column: 10, scope: !728)
!728 = distinct !DILexicalBlock(scope: !724, file: !32, line: 745, column: 9)
!729 = !DILocation(line: 745, column: 21, scope: !728)
!730 = !DILocation(line: 745, column: 29, scope: !728, atomGroup: 1, atomRank: 2)
!731 = !DILocation(line: 745, column: 34, scope: !728, atomGroup: 1, atomRank: 1)
!732 = !DILocation(line: 746, column: 9, scope: !728)
!733 = !DILocation(line: 746, column: 73, scope: !728, atomGroup: 2, atomRank: 2)
!734 = !DILocation(line: 745, column: 34, scope: !728, atomGroup: 2, atomRank: 1)
!735 = !DILocation(line: 747, column: 17, scope: !736)
!736 = distinct !DILexicalBlock(scope: !728, file: !32, line: 746, column: 79)
!737 = !DILocation(line: 747, column: 9, scope: !736)
!738 = !DILocation(line: 751, column: 1, scope: !724, atomGroup: 5, atomRank: 1)
!739 = !DILocation(line: 750, column: 5, scope: !740, atomGroup: 4, atomRank: 1)
!740 = distinct !DILexicalBlock(scope: !724, file: !32, line: 750, column: 5)
!741 = !DILocation(line: 750, column: 5, scope: !740)
!742 = distinct !DISubprogram(name: "floppy_legacy_boot", scope: !32, file: !32, line: 895, type: !18, scopeLine: 895, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!743 = !DILocation(line: 896, column: 25, scope: !742)
!744 = !DILocation(line: 896, column: 33, scope: !742)
!745 = !DILocation(line: 896, column: 41, scope: !742)
!746 = !DILocation(line: 896, column: 39, scope: !742, atomGroup: 1, atomRank: 3)
!747 = !DILocation(line: 897, column: 14, scope: !742, atomGroup: 2, atomRank: 2)
!748 = !DILocation(line: 897, column: 14, scope: !742, atomGroup: 2, atomRank: 1)
!749 = !DILocation(line: 898, column: 5, scope: !742)
!750 = !DILocation(line: 899, column: 26, scope: !742, atomGroup: 3, atomRank: 1)
!751 = !DILocation(line: 900, column: 5, scope: !742)
!752 = !DILocation(line: 901, column: 15, scope: !742, atomGroup: 4, atomRank: 1)
!753 = !DILocation(line: 902, column: 5, scope: !742)
!754 = !DILocation(line: 903, column: 1, scope: !742, atomGroup: 5, atomRank: 1)
!755 = distinct !DISubprogram(name: "fdc_read_data_from_current_location", scope: !32, file: !32, line: 758, type: !756, scopeLine: 758, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !758, keyInstructions: true)
!756 = !DISubroutineType(types: !757)
!757 = !{null, !5}
!758 = !{!759, !760, !762, !764}
!759 = !DILocalVariable(name: "total_bytes_to_read", arg: 1, scope: !755, file: !32, line: 758, type: !5)
!760 = !DILocalVariable(name: "r", scope: !761, file: !32, line: 762, type: !11)
!761 = distinct !DILexicalBlock(scope: !755, file: !32, line: 761, column: 15)
!762 = !DILocalVariable(name: "remaining", scope: !763, file: !32, line: 779, type: !23)
!763 = distinct !DILexicalBlock(scope: !761, file: !32, line: 778, column: 9)
!764 = !DILocalVariable(name: "max_head", scope: !765, file: !32, line: 802, type: !11)
!765 = distinct !DILexicalBlock(scope: !761, file: !32, line: 801, column: 9)
!766 = !DILocation(line: 0, scope: !755)
!767 = !DILocation(line: 759, column: 24, scope: !755, atomGroup: 1, atomRank: 1)
!768 = !DILocation(line: 761, column: 5, scope: !755)
!769 = !DILocation(line: 762, column: 18, scope: !761, atomGroup: 2, atomRank: 2)
!770 = !DILocation(line: 0, scope: !761)
!771 = !DILocation(line: 763, column: 15, scope: !772, atomGroup: 3, atomRank: 1)
!772 = distinct !DILexicalBlock(scope: !761, file: !32, line: 763, column: 13)
!773 = !DILocation(line: 764, column: 13, scope: !774)
!774 = distinct !DILexicalBlock(scope: !772, file: !32, line: 763, column: 21)
!775 = !DILocation(line: 765, column: 13, scope: !774, atomGroup: 4, atomRank: 1)
!776 = !DILocation(line: 768, column: 13, scope: !777)
!777 = distinct !DILexicalBlock(scope: !778, file: !32, line: 767, column: 21)
!778 = distinct !DILexicalBlock(scope: !761, file: !32, line: 767, column: 13)
!779 = !DILocation(line: 769, column: 13, scope: !777, atomGroup: 6, atomRank: 1)
!780 = !DILocation(line: 780, column: 13, scope: !763)
!781 = !DILocation(line: 781, column: 35, scope: !763)
!782 = !DILocation(line: 781, column: 66, scope: !763)
!783 = !DILocation(line: 781, column: 54, scope: !763, atomGroup: 7, atomRank: 2)
!784 = !DILocation(line: 0, scope: !763)
!785 = !DILocation(line: 782, column: 27, scope: !786, atomGroup: 8, atomRank: 2)
!786 = distinct !DILexicalBlock(scope: !763, file: !32, line: 782, column: 17)
!787 = !DILocation(line: 782, column: 27, scope: !786, atomGroup: 8, atomRank: 1)
!788 = !DILocation(line: 787, column: 35, scope: !789, atomGroup: 12, atomRank: 1)
!789 = distinct !DILexicalBlock(scope: !786, file: !32, line: 785, column: 20)
!790 = !DILocation(line: 0, scope: !786)
!791 = !DILocation(line: 792, column: 13, scope: !792)
!792 = distinct !DILexicalBlock(scope: !761, file: !32, line: 792, column: 13)
!793 = !DILocation(line: 792, column: 52, scope: !792, atomGroup: 14, atomRank: 2)
!794 = !DILocation(line: 792, column: 52, scope: !792, atomGroup: 14, atomRank: 1)
!795 = !DILocation(line: 793, column: 13, scope: !796)
!796 = distinct !DILexicalBlock(scope: !792, file: !32, line: 792, column: 58)
!797 = !DILocation(line: 794, column: 13, scope: !796, atomGroup: 15, atomRank: 1)
!798 = !DILocation(line: 797, column: 33, scope: !761)
!799 = !DILocation(line: 797, column: 30, scope: !761)
!800 = !DILocation(line: 797, column: 30, scope: !761, atomGroup: 16, atomRank: 2)
!801 = !DILocation(line: 797, column: 30, scope: !761, atomGroup: 16, atomRank: 1)
!802 = !DILocation(line: 798, column: 27, scope: !761, atomGroup: 17, atomRank: 1)
!803 = !DILocation(line: 803, column: 28, scope: !765, atomGroup: 18, atomRank: 1)
!804 = !DILocation(line: 804, column: 24, scope: !765, atomGroup: 19, atomRank: 2)
!805 = !DILocation(line: 0, scope: !765)
!806 = !DILocation(line: 805, column: 37, scope: !807)
!807 = distinct !DILexicalBlock(scope: !765, file: !32, line: 805, column: 17)
!808 = !DILocation(line: 805, column: 26, scope: !807, atomGroup: 20, atomRank: 2)
!809 = !DILocation(line: 805, column: 26, scope: !807, atomGroup: 20, atomRank: 1)
!810 = !DILocation(line: 807, column: 33, scope: !811)
!811 = distinct !DILexicalBlock(scope: !807, file: !32, line: 805, column: 43)
!812 = !DILocation(line: 807, column: 33, scope: !811, atomGroup: 22, atomRank: 2)
!813 = !DILocation(line: 807, column: 33, scope: !811, atomGroup: 22, atomRank: 1)
!814 = !DILocation(line: 808, column: 13, scope: !811)
!815 = !DILocation(line: 809, column: 29, scope: !816, atomGroup: 23, atomRank: 2)
!816 = distinct !DILexicalBlock(scope: !807, file: !32, line: 808, column: 20)
!817 = !DILocation(line: 0, scope: !807)
!818 = !DILocation(line: 813, column: 14, scope: !819)
!819 = distinct !DILexicalBlock(scope: !761, file: !32, line: 813, column: 13)
!820 = !DILocation(line: 813, column: 14, scope: !819, atomGroup: 24, atomRank: 2)
!821 = !DILocation(line: 817, column: 1, scope: !755, atomGroup: 26, atomRank: 1)
!822 = distinct !DISubprogram(name: "syscall", scope: !32, file: !32, line: 907, type: !823, scopeLine: 907, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !825, keyInstructions: true)
!823 = !DISubroutineType(types: !824)
!824 = !{null, !5, !5}
!825 = !{!826, !827, !828, !829}
!826 = !DILocalVariable(name: "addr", arg: 1, scope: !822, file: !32, line: 907, type: !5)
!827 = !DILocalVariable(name: "de", arg: 2, scope: !822, file: !32, line: 907, type: !5)
!828 = !DILocalVariable(name: "d", scope: !822, file: !32, line: 908, type: !11)
!829 = !DILocalVariable(name: "e", scope: !822, file: !32, line: 909, type: !11)
!830 = !DILocation(line: 0, scope: !822)
!831 = !DILocation(line: 908, column: 25, scope: !822, atomGroup: 1, atomRank: 3)
!832 = !DILocation(line: 911, column: 26, scope: !822, atomGroup: 3, atomRank: 1)
!833 = !DILocation(line: 912, column: 22, scope: !822, atomGroup: 4, atomRank: 2)
!834 = !DILocation(line: 912, column: 20, scope: !822, atomGroup: 4, atomRank: 1)
!835 = !DILocation(line: 913, column: 26, scope: !822, atomGroup: 5, atomRank: 3)
!836 = !DILocation(line: 913, column: 24, scope: !822, atomGroup: 5, atomRank: 2)
!837 = !DILocation(line: 913, column: 22, scope: !822, atomGroup: 5, atomRank: 1)
!838 = !DILocation(line: 915, column: 26, scope: !839, atomGroup: 6, atomRank: 2)
!839 = distinct !DILexicalBlock(scope: !822, file: !32, line: 915, column: 9)
!840 = !DILocation(line: 915, column: 26, scope: !839, atomGroup: 6, atomRank: 1)
!841 = !DILocation(line: 916, column: 9, scope: !842)
!842 = distinct !DILexicalBlock(scope: !839, file: !32, line: 915, column: 32)
!843 = !DILocation(line: 919, column: 20, scope: !822, atomGroup: 7, atomRank: 2)
!844 = !DILocation(line: 919, column: 18, scope: !822, atomGroup: 7, atomRank: 1)
!845 = !DILocation(line: 920, column: 5, scope: !822)
!846 = !DILocation(line: 923, column: 26, scope: !847, atomGroup: 9, atomRank: 1)
!847 = distinct !DILexicalBlock(scope: !848, file: !32, line: 922, column: 32)
!848 = distinct !DILexicalBlock(scope: !822, file: !32, line: 922, column: 9)
!849 = !DILocation(line: 924, column: 9, scope: !847)
!850 = !DILocation(line: 925, column: 5, scope: !847)
!851 = !DILocation(line: 919, column: 20, scope: !822, atomGroup: 27, atomRank: 2)
!852 = !DILocation(line: 919, column: 18, scope: !822, atomGroup: 27, atomRank: 1)
!853 = !DILocation(line: 922, column: 26, scope: !848, atomGroup: 8, atomRank: 1)
!854 = !DILocation(line: 926, column: 1, scope: !822, atomGroup: 10, atomRank: 1)
!855 = distinct !DISubprogram(name: "nothing_int", scope: !32, file: !32, line: 939, type: !18, scopeLine: 939, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!856 = !DILocation(line: 940, column: 1, scope: !855, atomGroup: 1, atomRank: 1)
!857 = distinct !DISubprogram(name: "refresh_crt_dma_50hz_interrupt", scope: !32, file: !32, line: 953, type: !18, scopeLine: 953, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !858, keyInstructions: true)
!858 = !{!859, !861}
!859 = !DILocalVariable(name: "_t", scope: !860, file: !32, line: 959, type: !5)
!860 = distinct !DILexicalBlock(scope: !857, file: !32, line: 959, column: 5)
!861 = !DILocalVariable(name: "_t", scope: !862, file: !32, line: 960, type: !5)
!862 = distinct !DILexicalBlock(scope: !857, file: !32, line: 960, column: 5)
!863 = !DILocation(line: 164, column: 1, scope: !864, inlinedAt: !865, atomGroup: 1, atomRank: 2)
!864 = distinct !DISubprogram(name: "port_in_crt_cmd", scope: !6, file: !6, line: 164, type: !181, scopeLine: 164, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!865 = distinct !DILocation(line: 954, column: 12, scope: !857)
!866 = !DILocation(line: 0, scope: !571, inlinedAt: !867)
!867 = distinct !DILocation(line: 956, column: 5, scope: !857)
!868 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !867, atomGroup: 1, atomRank: 1)
!869 = !DILocation(line: 0, scope: !583, inlinedAt: !870)
!870 = distinct !DILocation(line: 957, column: 5, scope: !857)
!871 = !DILocation(line: 199, column: 1, scope: !583, inlinedAt: !870, atomGroup: 1, atomRank: 1)
!872 = !DILocation(line: 0, scope: !860)
!873 = !DILocalVariable(name: "val", arg: 1, scope: !874, file: !6, line: 192, type: !12)
!874 = distinct !DISubprogram(name: "port_out_dma_ch2_addr", scope: !6, file: !6, line: 192, type: !191, scopeLine: 192, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !875, keyInstructions: true)
!875 = !{!873}
!876 = !DILocation(line: 0, scope: !874, inlinedAt: !877)
!877 = distinct !DILocation(line: 959, column: 5, scope: !860)
!878 = !DILocation(line: 192, column: 1, scope: !874, inlinedAt: !877, atomGroup: 1, atomRank: 1)
!879 = !DILocation(line: 0, scope: !874, inlinedAt: !880)
!880 = distinct !DILocation(line: 959, column: 5, scope: !860)
!881 = !DILocation(line: 192, column: 1, scope: !874, inlinedAt: !880, atomGroup: 1, atomRank: 1)
!882 = !DILocation(line: 0, scope: !862)
!883 = !DILocalVariable(name: "val", arg: 1, scope: !884, file: !6, line: 193, type: !12)
!884 = distinct !DISubprogram(name: "port_out_dma_ch2_wc", scope: !6, file: !6, line: 193, type: !191, scopeLine: 193, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !885, keyInstructions: true)
!885 = !{!883}
!886 = !DILocation(line: 0, scope: !884, inlinedAt: !887)
!887 = distinct !DILocation(line: 960, column: 5, scope: !862)
!888 = !DILocation(line: 193, column: 1, scope: !884, inlinedAt: !887, atomGroup: 1, atomRank: 1)
!889 = !DILocation(line: 0, scope: !884, inlinedAt: !890)
!890 = distinct !DILocation(line: 960, column: 5, scope: !862)
!891 = !DILocation(line: 193, column: 1, scope: !884, inlinedAt: !890, atomGroup: 1, atomRank: 1)
!892 = !DILocation(line: 0, scope: !571, inlinedAt: !893)
!893 = distinct !DILocation(line: 962, column: 5, scope: !857)
!894 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !893, atomGroup: 1, atomRank: 1)
!895 = !DILocalVariable(name: "val", arg: 1, scope: !896, file: !6, line: 169, type: !12)
!896 = distinct !DISubprogram(name: "port_out_ctc2", scope: !6, file: !6, line: 169, type: !191, scopeLine: 169, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !897, keyInstructions: true)
!897 = !{!895}
!898 = !DILocation(line: 0, scope: !896, inlinedAt: !899)
!899 = distinct !DILocation(line: 964, column: 5, scope: !857)
!900 = !DILocation(line: 169, column: 1, scope: !896, inlinedAt: !899, atomGroup: 1, atomRank: 1)
!901 = !DILocation(line: 0, scope: !896, inlinedAt: !902)
!902 = distinct !DILocation(line: 965, column: 5, scope: !857)
!903 = !DILocation(line: 169, column: 1, scope: !896, inlinedAt: !902, atomGroup: 1, atomRank: 1)
!904 = !DILocation(line: 966, column: 1, scope: !857, atomGroup: 3, atomRank: 1)
!905 = distinct !DISubprogram(name: "floppy_completed_operation_interrupt", scope: !32, file: !32, line: 970, type: !18, scopeLine: 970, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!906 = !DILocation(line: 971, column: 37, scope: !905, atomGroup: 1, atomRank: 1)
!907 = !DILocation(line: 165, column: 1, scope: !180, inlinedAt: !908, atomGroup: 1, atomRank: 2)
!908 = distinct !DILocation(line: 973, column: 9, scope: !909)
!909 = distinct !DILexicalBlock(scope: !905, file: !32, line: 973, column: 9)
!910 = !DILocation(line: 973, column: 22, scope: !909)
!911 = !DILocation(line: 973, column: 22, scope: !909, atomGroup: 2, atomRank: 2)
!912 = !DILocation(line: 973, column: 22, scope: !909, atomGroup: 2, atomRank: 1)
!913 = !DILocation(line: 974, column: 9, scope: !914)
!914 = distinct !DILexicalBlock(scope: !909, file: !32, line: 973, column: 36)
!915 = !DILocation(line: 975, column: 5, scope: !914)
!916 = !DILocation(line: 976, column: 9, scope: !917)
!917 = distinct !DILexicalBlock(scope: !909, file: !32, line: 975, column: 12)
!918 = !DILocation(line: 978, column: 1, scope: !905, atomGroup: 3, atomRank: 1)
!919 = distinct !DISubprogram(name: "main_relocated", scope: !32, file: !32, line: 989, type: !18, scopeLine: 990, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!920 = !DILocation(line: 991, column: 5, scope: !919, atomGroup: 1, atomRank: 1)
!921 = !{i64 2147621615}
!922 = !DILocalVariable(name: "page", arg: 1, scope: !923, file: !391, line: 27, type: !13)
!923 = distinct !DISubprogram(name: "set_i_reg", scope: !391, file: !391, line: 27, type: !924, scopeLine: 27, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !926, keyInstructions: true)
!924 = !DISubroutineType(types: !925)
!925 = !{null, !13}
!926 = !{!922}
!927 = !DILocation(line: 0, scope: !923, inlinedAt: !928)
!928 = distinct !DILocation(line: 992, column: 5, scope: !919)
!929 = !DILocation(line: 28, column: 5, scope: !923, inlinedAt: !928, atomGroup: 1, atomRank: 1)
!930 = !{i64 119531}
!931 = !DILocation(line: 238, column: 43, scope: !932, inlinedAt: !933, atomGroup: 1, atomRank: 1)
!932 = distinct !DISubprogram(name: "intrinsic_im_2", scope: !6, file: !6, line: 238, type: !18, scopeLine: 238, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!933 = distinct !DILocation(line: 993, column: 5, scope: !919)
!934 = !{i64 74834}
!935 = !DILocalVariable(name: "val", arg: 1, scope: !936, file: !6, line: 173, type: !12)
!936 = distinct !DISubprogram(name: "port_out_pio_a_ctrl", scope: !6, file: !6, line: 173, type: !191, scopeLine: 173, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !937, keyInstructions: true)
!937 = !{!935}
!938 = !DILocation(line: 0, scope: !936, inlinedAt: !939)
!939 = distinct !DILocation(line: 130, column: 5, scope: !940, inlinedAt: !941)
!940 = distinct !DISubprogram(name: "init_pio", scope: !32, file: !32, line: 128, type: !18, scopeLine: 128, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!941 = distinct !DILocation(line: 994, column: 5, scope: !919)
!942 = !DILocation(line: 173, column: 1, scope: !936, inlinedAt: !939, atomGroup: 1, atomRank: 1)
!943 = !DILocalVariable(name: "val", arg: 1, scope: !944, file: !6, line: 174, type: !12)
!944 = distinct !DISubprogram(name: "port_out_pio_b_ctrl", scope: !6, file: !6, line: 174, type: !191, scopeLine: 174, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !945, keyInstructions: true)
!945 = !{!943}
!946 = !DILocation(line: 0, scope: !944, inlinedAt: !947)
!947 = distinct !DILocation(line: 131, column: 5, scope: !940, inlinedAt: !941)
!948 = !DILocation(line: 174, column: 1, scope: !944, inlinedAt: !947, atomGroup: 1, atomRank: 1)
!949 = !DILocation(line: 0, scope: !936, inlinedAt: !950)
!950 = distinct !DILocation(line: 132, column: 5, scope: !940, inlinedAt: !941)
!951 = !DILocation(line: 173, column: 1, scope: !936, inlinedAt: !950, atomGroup: 1, atomRank: 1)
!952 = !DILocation(line: 0, scope: !944, inlinedAt: !953)
!953 = distinct !DILocation(line: 133, column: 5, scope: !940, inlinedAt: !941)
!954 = !DILocation(line: 174, column: 1, scope: !944, inlinedAt: !953, atomGroup: 1, atomRank: 1)
!955 = !DILocation(line: 0, scope: !936, inlinedAt: !956)
!956 = distinct !DILocation(line: 134, column: 5, scope: !940, inlinedAt: !941)
!957 = !DILocation(line: 173, column: 1, scope: !936, inlinedAt: !956, atomGroup: 1, atomRank: 1)
!958 = !DILocation(line: 0, scope: !944, inlinedAt: !959)
!959 = distinct !DILocation(line: 135, column: 5, scope: !940, inlinedAt: !941)
!960 = !DILocation(line: 174, column: 1, scope: !944, inlinedAt: !959, atomGroup: 1, atomRank: 1)
!961 = !DILocalVariable(name: "val", arg: 1, scope: !962, file: !6, line: 167, type: !12)
!962 = distinct !DISubprogram(name: "port_out_ctc0", scope: !6, file: !6, line: 167, type: !191, scopeLine: 167, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !963, keyInstructions: true)
!963 = !{!961}
!964 = !DILocation(line: 0, scope: !962, inlinedAt: !965)
!965 = distinct !DILocation(line: 140, column: 5, scope: !966, inlinedAt: !967)
!966 = distinct !DISubprogram(name: "init_ctc", scope: !32, file: !32, line: 138, type: !18, scopeLine: 138, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!967 = distinct !DILocation(line: 995, column: 5, scope: !919)
!968 = !DILocation(line: 167, column: 1, scope: !962, inlinedAt: !965, atomGroup: 1, atomRank: 1)
!969 = !DILocation(line: 0, scope: !962, inlinedAt: !970)
!970 = distinct !DILocation(line: 141, column: 5, scope: !966, inlinedAt: !967)
!971 = !DILocation(line: 167, column: 1, scope: !962, inlinedAt: !970, atomGroup: 1, atomRank: 1)
!972 = !DILocation(line: 0, scope: !962, inlinedAt: !973)
!973 = distinct !DILocation(line: 142, column: 5, scope: !966, inlinedAt: !967)
!974 = !DILocation(line: 167, column: 1, scope: !962, inlinedAt: !973, atomGroup: 1, atomRank: 1)
!975 = !DILocalVariable(name: "val", arg: 1, scope: !976, file: !6, line: 168, type: !12)
!976 = distinct !DISubprogram(name: "port_out_ctc1", scope: !6, file: !6, line: 168, type: !191, scopeLine: 168, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !977, keyInstructions: true)
!977 = !{!975}
!978 = !DILocation(line: 0, scope: !976, inlinedAt: !979)
!979 = distinct !DILocation(line: 143, column: 5, scope: !966, inlinedAt: !967)
!980 = !DILocation(line: 168, column: 1, scope: !976, inlinedAt: !979, atomGroup: 1, atomRank: 1)
!981 = !DILocation(line: 0, scope: !976, inlinedAt: !982)
!982 = distinct !DILocation(line: 144, column: 5, scope: !966, inlinedAt: !967)
!983 = !DILocation(line: 168, column: 1, scope: !976, inlinedAt: !982, atomGroup: 1, atomRank: 1)
!984 = !DILocation(line: 0, scope: !896, inlinedAt: !985)
!985 = distinct !DILocation(line: 145, column: 5, scope: !966, inlinedAt: !967)
!986 = !DILocation(line: 169, column: 1, scope: !896, inlinedAt: !985, atomGroup: 1, atomRank: 1)
!987 = !DILocation(line: 0, scope: !896, inlinedAt: !988)
!988 = distinct !DILocation(line: 146, column: 5, scope: !966, inlinedAt: !967)
!989 = !DILocation(line: 169, column: 1, scope: !896, inlinedAt: !988, atomGroup: 1, atomRank: 1)
!990 = !DILocation(line: 0, scope: !657, inlinedAt: !991)
!991 = distinct !DILocation(line: 147, column: 5, scope: !966, inlinedAt: !967)
!992 = !DILocation(line: 170, column: 1, scope: !657, inlinedAt: !991, atomGroup: 1, atomRank: 1)
!993 = !DILocation(line: 0, scope: !657, inlinedAt: !994)
!994 = distinct !DILocation(line: 148, column: 5, scope: !966, inlinedAt: !967)
!995 = !DILocation(line: 170, column: 1, scope: !657, inlinedAt: !994, atomGroup: 1, atomRank: 1)
!996 = !DILocalVariable(name: "val", arg: 1, scope: !997, file: !6, line: 196, type: !12)
!997 = distinct !DISubprogram(name: "port_out_dma_cmd", scope: !6, file: !6, line: 196, type: !191, scopeLine: 196, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !998, keyInstructions: true)
!998 = !{!996}
!999 = !DILocation(line: 0, scope: !997, inlinedAt: !1000)
!1000 = distinct !DILocation(line: 153, column: 5, scope: !1001, inlinedAt: !1002)
!1001 = distinct !DISubprogram(name: "init_dma", scope: !32, file: !32, line: 151, type: !18, scopeLine: 151, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!1002 = distinct !DILocation(line: 996, column: 5, scope: !919)
!1003 = !DILocation(line: 196, column: 1, scope: !997, inlinedAt: !1000, atomGroup: 1, atomRank: 1)
!1004 = !DILocation(line: 0, scope: !577, inlinedAt: !1005)
!1005 = distinct !DILocation(line: 154, column: 5, scope: !1001, inlinedAt: !1002)
!1006 = !DILocation(line: 198, column: 1, scope: !577, inlinedAt: !1005, atomGroup: 1, atomRank: 1)
!1007 = !DILocation(line: 0, scope: !571, inlinedAt: !1008)
!1008 = distinct !DILocation(line: 155, column: 5, scope: !1001, inlinedAt: !1002)
!1009 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !1008, atomGroup: 1, atomRank: 1)
!1010 = !DILocation(line: 0, scope: !577, inlinedAt: !1011)
!1011 = distinct !DILocation(line: 156, column: 5, scope: !1001, inlinedAt: !1002)
!1012 = !DILocation(line: 198, column: 1, scope: !577, inlinedAt: !1011, atomGroup: 1, atomRank: 1)
!1013 = !DILocalVariable(name: "val", arg: 1, scope: !1014, file: !6, line: 164, type: !12)
!1014 = distinct !DISubprogram(name: "port_out_crt_cmd", scope: !6, file: !6, line: 164, type: !191, scopeLine: 164, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1015, keyInstructions: true)
!1015 = !{!1013}
!1016 = !DILocation(line: 0, scope: !1014, inlinedAt: !1017)
!1017 = distinct !DILocation(line: 161, column: 5, scope: !1018, inlinedAt: !1019)
!1018 = distinct !DISubprogram(name: "init_crt", scope: !32, file: !32, line: 159, type: !18, scopeLine: 159, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!1019 = distinct !DILocation(line: 997, column: 5, scope: !919)
!1020 = !DILocation(line: 164, column: 1, scope: !1014, inlinedAt: !1017, atomGroup: 1, atomRank: 1)
!1021 = !DILocalVariable(name: "val", arg: 1, scope: !1022, file: !6, line: 163, type: !12)
!1022 = distinct !DISubprogram(name: "port_out_crt_param", scope: !6, file: !6, line: 163, type: !191, scopeLine: 163, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1023, keyInstructions: true)
!1023 = !{!1021}
!1024 = !DILocation(line: 0, scope: !1022, inlinedAt: !1025)
!1025 = distinct !DILocation(line: 162, column: 5, scope: !1018, inlinedAt: !1019)
!1026 = !DILocation(line: 163, column: 1, scope: !1022, inlinedAt: !1025, atomGroup: 1, atomRank: 1)
!1027 = !DILocation(line: 0, scope: !1022, inlinedAt: !1028)
!1028 = distinct !DILocation(line: 163, column: 5, scope: !1018, inlinedAt: !1019)
!1029 = !DILocation(line: 163, column: 1, scope: !1022, inlinedAt: !1028, atomGroup: 1, atomRank: 1)
!1030 = !DILocation(line: 0, scope: !1022, inlinedAt: !1031)
!1031 = distinct !DILocation(line: 164, column: 5, scope: !1018, inlinedAt: !1019)
!1032 = !DILocation(line: 163, column: 1, scope: !1022, inlinedAt: !1031, atomGroup: 1, atomRank: 1)
!1033 = !DILocation(line: 0, scope: !1022, inlinedAt: !1034)
!1034 = distinct !DILocation(line: 165, column: 5, scope: !1018, inlinedAt: !1019)
!1035 = !DILocation(line: 163, column: 1, scope: !1022, inlinedAt: !1034, atomGroup: 1, atomRank: 1)
!1036 = !DILocation(line: 0, scope: !1014, inlinedAt: !1037)
!1037 = distinct !DILocation(line: 166, column: 5, scope: !1018, inlinedAt: !1019)
!1038 = !DILocation(line: 164, column: 1, scope: !1014, inlinedAt: !1037, atomGroup: 1, atomRank: 1)
!1039 = !DILocation(line: 0, scope: !1022, inlinedAt: !1040)
!1040 = distinct !DILocation(line: 167, column: 5, scope: !1018, inlinedAt: !1019)
!1041 = !DILocation(line: 163, column: 1, scope: !1022, inlinedAt: !1040, atomGroup: 1, atomRank: 1)
!1042 = !DILocation(line: 0, scope: !1022, inlinedAt: !1043)
!1043 = distinct !DILocation(line: 168, column: 5, scope: !1018, inlinedAt: !1019)
!1044 = !DILocation(line: 163, column: 1, scope: !1022, inlinedAt: !1043, atomGroup: 1, atomRank: 1)
!1045 = !DILocation(line: 0, scope: !1014, inlinedAt: !1046)
!1046 = distinct !DILocation(line: 169, column: 5, scope: !1018, inlinedAt: !1019)
!1047 = !DILocation(line: 164, column: 1, scope: !1014, inlinedAt: !1046, atomGroup: 1, atomRank: 1)
!1048 = !DILocation(line: 1001, column: 5, scope: !919)
!1049 = !DILocation(line: 820, column: 5, scope: !1050, inlinedAt: !1051)
!1050 = distinct !DISubprogram(name: "init_fdc", scope: !32, file: !32, line: 819, type: !18, scopeLine: 819, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!1051 = distinct !DILocation(line: 1002, column: 5, scope: !919)
!1052 = !DILocation(line: 821, column: 5, scope: !1050, inlinedAt: !1051)
!1053 = !DILocation(line: 165, column: 1, scope: !180, inlinedAt: !1054, atomGroup: 1, atomRank: 2)
!1054 = distinct !DILocation(line: 821, column: 12, scope: !1050, inlinedAt: !1051)
!1055 = !DILocation(line: 821, column: 32, scope: !1050, inlinedAt: !1051)
!1056 = !DILocation(line: 821, column: 5, scope: !1050, inlinedAt: !1051, atomGroup: 1, atomRank: 1)
!1057 = !DILocation(line: 821, column: 5, scope: !1050, inlinedAt: !1051, atomGroup: 2, atomRank: 1)
!1058 = distinct !{!1058, !1052, !1059, !204}
!1059 = !DILocation(line: 822, column: 9, scope: !1050, inlinedAt: !1051)
!1060 = !DILocation(line: 823, column: 5, scope: !1050, inlinedAt: !1051)
!1061 = !DILocation(line: 824, column: 5, scope: !1050, inlinedAt: !1051)
!1062 = !DILocation(line: 825, column: 5, scope: !1050, inlinedAt: !1051)
!1063 = !DILocation(line: 1003, column: 5, scope: !919, atomGroup: 2, atomRank: 1)
!1064 = !DILocation(line: 1004, column: 5, scope: !919)
!1065 = !DILocation(line: 831, column: 19, scope: !1066, inlinedAt: !1067, atomGroup: 1, atomRank: 1)
!1066 = distinct !DISubprogram(name: "get_floppy_ready", scope: !32, file: !32, line: 830, type: !18, scopeLine: 830, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!1067 = distinct !DILocation(line: 1005, column: 5, scope: !919)
!1068 = !DILocation(line: 832, column: 22, scope: !1066, inlinedAt: !1067, atomGroup: 2, atomRank: 1)
!1069 = !DILocation(line: 175, column: 1, scope: !726, inlinedAt: !1070, atomGroup: 1, atomRank: 2)
!1070 = distinct !DILocation(line: 833, column: 16, scope: !1066, inlinedAt: !1067)
!1071 = !DILocation(line: 833, column: 27, scope: !1066, inlinedAt: !1067)
!1072 = !DILocation(line: 833, column: 13, scope: !1066, inlinedAt: !1067, atomGroup: 3, atomRank: 1)
!1073 = !DILocation(line: 16, column: 5, scope: !390, inlinedAt: !1074, atomGroup: 1, atomRank: 1)
!1074 = distinct !DILocation(line: 835, column: 5, scope: !1066, inlinedAt: !1067)
!1075 = !DILocalVariable(name: "val", arg: 1, scope: !1076, file: !6, line: 175, type: !12)
!1076 = distinct !DISubprogram(name: "port_out_sw1", scope: !6, file: !6, line: 175, type: !191, scopeLine: 175, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1077, keyInstructions: true)
!1077 = !{!1075}
!1078 = !DILocation(line: 0, scope: !1076, inlinedAt: !1079)
!1079 = distinct !DILocation(line: 836, column: 5, scope: !1066, inlinedAt: !1067)
!1080 = !DILocation(line: 175, column: 1, scope: !1076, inlinedAt: !1079, atomGroup: 1, atomRank: 1)
!1081 = !DILocation(line: 837, column: 17, scope: !1066, inlinedAt: !1067, atomGroup: 4, atomRank: 1)
!1082 = !DILocation(line: 838, column: 5, scope: !1066, inlinedAt: !1067)
!1083 = !DILocation(line: 1007, column: 5, scope: !919)
!1084 = !DILocation(line: 1007, column: 5, scope: !1085, atomGroup: 3, atomRank: 1)
!1085 = distinct !DILexicalBlock(scope: !1086, file: !32, line: 1007, column: 5)
!1086 = distinct !DILexicalBlock(scope: !919, file: !32, line: 1007, column: 5)
!1087 = distinct !{!1087, !1088, !1089}
!1088 = !DILocation(line: 1007, column: 5, scope: !1086)
!1089 = !DILocation(line: 1007, column: 13, scope: !1086)
!1090 = distinct !DISubprogram(name: "load_chargen_font", scope: !32, file: !32, line: 197, type: !18, scopeLine: 198, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1091, keyInstructions: true)
!1091 = !{!1092, !1093, !1094}
!1092 = !DILocalVariable(name: "line", scope: !1090, file: !32, line: 199, type: !11)
!1093 = !DILocalVariable(name: "ch", scope: !1090, file: !32, line: 199, type: !11)
!1094 = !DILocalVariable(name: "p", scope: !1090, file: !32, line: 200, type: !15)
!1095 = !DILocation(line: 0, scope: !1090)
!1096 = !DILocation(line: 209, column: 10, scope: !1097)
!1097 = distinct !DILexicalBlock(scope: !1090, file: !32, line: 209, column: 5)
!1098 = !DILocation(line: 209, scope: !1097, atomGroup: 2, atomRank: 1)
!1099 = !DILocation(line: 200, column: 17, scope: !1090, atomGroup: 1, atomRank: 1)
!1100 = !DILocation(line: 209, column: 25, scope: !1101, atomGroup: 3, atomRank: 1)
!1101 = distinct !DILexicalBlock(scope: !1097, file: !32, line: 209, column: 5)
!1102 = !DILocation(line: 209, column: 5, scope: !1097, atomGroup: 4, atomRank: 1)
!1103 = !DILocalVariable(name: "val", arg: 1, scope: !1104, file: !6, line: 188, type: !12)
!1104 = distinct !DISubprogram(name: "port_out_chargen_dot", scope: !6, file: !6, line: 188, type: !191, scopeLine: 188, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1105, keyInstructions: true)
!1105 = !{!1103}
!1106 = !DILocation(line: 0, scope: !1104, inlinedAt: !1107)
!1107 = distinct !DILocation(line: 210, column: 9, scope: !1108)
!1108 = distinct !DILexicalBlock(scope: !1101, file: !32, line: 209, column: 54)
!1109 = !DILocation(line: 188, column: 1, scope: !1104, inlinedAt: !1107, atomGroup: 1, atomRank: 1)
!1110 = !DILocation(line: 211, column: 14, scope: !1111)
!1111 = distinct !DILexicalBlock(scope: !1108, file: !32, line: 211, column: 9)
!1112 = !DILocation(line: 211, scope: !1111, atomGroup: 5, atomRank: 1)
!1113 = !DILocation(line: 211, column: 25, scope: !1114, atomGroup: 6, atomRank: 1)
!1114 = distinct !DILexicalBlock(scope: !1111, file: !32, line: 211, column: 9)
!1115 = !DILocation(line: 211, column: 9, scope: !1111, atomGroup: 7, atomRank: 1)
!1116 = !DILocalVariable(name: "val", arg: 1, scope: !1117, file: !6, line: 187, type: !12)
!1117 = distinct !DISubprogram(name: "port_out_chargen_char", scope: !6, file: !6, line: 187, type: !191, scopeLine: 187, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1118, keyInstructions: true)
!1118 = !{!1116}
!1119 = !DILocation(line: 0, scope: !1117, inlinedAt: !1120)
!1120 = distinct !DILocation(line: 212, column: 13, scope: !1121)
!1121 = distinct !DILexicalBlock(scope: !1114, file: !32, line: 211, column: 38)
!1122 = !DILocation(line: 187, column: 1, scope: !1117, inlinedAt: !1120, atomGroup: 1, atomRank: 1)
!1123 = !DILocation(line: 213, column: 38, scope: !1121, atomGroup: 8, atomRank: 2)
!1124 = !DILocation(line: 213, column: 36, scope: !1121)
!1125 = !DILocalVariable(name: "val", arg: 1, scope: !1126, file: !6, line: 189, type: !12)
!1126 = distinct !DISubprogram(name: "port_out_chargen_data", scope: !6, file: !6, line: 189, type: !191, scopeLine: 189, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1127, keyInstructions: true)
!1127 = !{!1125}
!1128 = !DILocation(line: 0, scope: !1126, inlinedAt: !1129)
!1129 = distinct !DILocation(line: 213, column: 13, scope: !1121)
!1130 = !DILocation(line: 189, column: 1, scope: !1126, inlinedAt: !1129, atomGroup: 1, atomRank: 1)
!1131 = !DILocation(line: 211, column: 34, scope: !1114, atomGroup: 9, atomRank: 2)
!1132 = !DILocation(line: 211, column: 9, scope: !1114)
!1133 = distinct !{!1133, !1134, !1135, !204}
!1134 = !DILocation(line: 211, column: 9, scope: !1111)
!1135 = !DILocation(line: 214, column: 9, scope: !1111)
!1136 = !DILocation(line: 209, column: 50, scope: !1101, atomGroup: 11, atomRank: 2)
!1137 = !DILocation(line: 209, column: 5, scope: !1101)
!1138 = distinct !{!1138, !1139, !1140, !204}
!1139 = !DILocation(line: 209, column: 5, scope: !1097)
!1140 = !DILocation(line: 215, column: 5, scope: !1097)
!1141 = !DILocation(line: 216, column: 1, scope: !1090, atomGroup: 13, atomRank: 1)
!1142 = distinct !DISubprogram(name: "display_banner_and_start_crt", scope: !32, file: !32, line: 304, type: !18, scopeLine: 304, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1143, keyInstructions: true)
!1143 = !{!1144, !1146}
!1144 = !DILocalVariable(name: "_t", scope: !1145, file: !32, line: 312, type: !5)
!1145 = distinct !DILexicalBlock(scope: !1142, file: !32, line: 312, column: 5)
!1146 = !DILocalVariable(name: "_t", scope: !1147, file: !32, line: 313, type: !5)
!1147 = distinct !DILexicalBlock(scope: !1142, file: !32, line: 313, column: 5)
!1148 = !DILocation(line: 305, column: 5, scope: !1142, atomGroup: 1, atomRank: 1)
!1149 = !DILocation(line: 306, column: 5, scope: !1142, atomGroup: 2, atomRank: 1)
!1150 = !DILocation(line: 307, column: 5, scope: !1142)
!1151 = !DILocation(line: 308, column: 5, scope: !1142)
!1152 = !DILocation(line: 0, scope: !571, inlinedAt: !1153)
!1153 = distinct !DILocation(line: 310, column: 5, scope: !1142)
!1154 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !1153, atomGroup: 1, atomRank: 1)
!1155 = !DILocation(line: 0, scope: !583, inlinedAt: !1156)
!1156 = distinct !DILocation(line: 311, column: 5, scope: !1142)
!1157 = !DILocation(line: 199, column: 1, scope: !583, inlinedAt: !1156, atomGroup: 1, atomRank: 1)
!1158 = !DILocation(line: 0, scope: !1145)
!1159 = !DILocation(line: 0, scope: !874, inlinedAt: !1160)
!1160 = distinct !DILocation(line: 312, column: 5, scope: !1145)
!1161 = !DILocation(line: 192, column: 1, scope: !874, inlinedAt: !1160, atomGroup: 1, atomRank: 1)
!1162 = !DILocation(line: 0, scope: !874, inlinedAt: !1163)
!1163 = distinct !DILocation(line: 312, column: 5, scope: !1145)
!1164 = !DILocation(line: 192, column: 1, scope: !874, inlinedAt: !1163, atomGroup: 1, atomRank: 1)
!1165 = !DILocation(line: 0, scope: !1147)
!1166 = !DILocation(line: 0, scope: !884, inlinedAt: !1167)
!1167 = distinct !DILocation(line: 313, column: 5, scope: !1147)
!1168 = !DILocation(line: 193, column: 1, scope: !884, inlinedAt: !1167, atomGroup: 1, atomRank: 1)
!1169 = !DILocation(line: 0, scope: !884, inlinedAt: !1170)
!1170 = distinct !DILocation(line: 313, column: 5, scope: !1147)
!1171 = !DILocation(line: 193, column: 1, scope: !884, inlinedAt: !1170, atomGroup: 1, atomRank: 1)
!1172 = !DILocation(line: 0, scope: !571, inlinedAt: !1173)
!1173 = distinct !DILocation(line: 314, column: 5, scope: !1142)
!1174 = !DILocation(line: 197, column: 1, scope: !571, inlinedAt: !1173, atomGroup: 1, atomRank: 1)
!1175 = !DILocation(line: 0, scope: !1014, inlinedAt: !1176)
!1176 = distinct !DILocation(line: 315, column: 5, scope: !1142)
!1177 = !DILocation(line: 164, column: 1, scope: !1014, inlinedAt: !1176, atomGroup: 1, atomRank: 1)
!1178 = !DILocation(line: 316, column: 1, scope: !1142, atomGroup: 5, atomRank: 1)
!1179 = !DILocation(line: 175, column: 1, scope: !726, inlinedAt: !1180, atomGroup: 1, atomRank: 2)
!1180 = distinct !DILocation(line: 246, column: 15, scope: !152)
!1181 = !DILocation(line: 0, scope: !152)
!1182 = !DILocation(line: 251, column: 5, scope: !152, atomGroup: 3, atomRank: 1)
!1183 = !DILocation(line: 254, column: 10, scope: !1184)
!1184 = distinct !DILexicalBlock(scope: !152, file: !32, line: 254, column: 5)
!1185 = !DILocation(line: 254, scope: !1184, atomGroup: 5, atomRank: 1)
!1186 = !DILocation(line: 254, column: 19, scope: !1187, atomGroup: 6, atomRank: 1)
!1187 = distinct !DILexicalBlock(scope: !1184, file: !32, line: 254, column: 5)
!1188 = !DILocation(line: 254, column: 5, scope: !1184, atomGroup: 7, atomRank: 1)
!1189 = !DILocation(line: 255, column: 33, scope: !1190)
!1190 = distinct !DILexicalBlock(scope: !1187, file: !32, line: 254, column: 29)
!1191 = !DILocation(line: 255, column: 27, scope: !1190, atomGroup: 8, atomRank: 3)
!1192 = !DILocation(line: 255, column: 11, scope: !1190, atomGroup: 9, atomRank: 2)
!1193 = !DILocation(line: 255, column: 14, scope: !1190, atomGroup: 8, atomRank: 1)
!1194 = !DILocation(line: 256, column: 12, scope: !1190, atomGroup: 10, atomRank: 3)
!1195 = !DILocation(line: 254, column: 25, scope: !1187, atomGroup: 11, atomRank: 2)
!1196 = !DILocation(line: 254, column: 5, scope: !1187)
!1197 = distinct !{!1197, !1198, !1199, !204}
!1198 = !DILocation(line: 254, column: 5, scope: !1184)
!1199 = !DILocation(line: 257, column: 5, scope: !1184)
!1200 = !DILocation(line: 258, column: 1, scope: !152, atomGroup: 13, atomRank: 1)
!1201 = distinct !DISubprogram(name: "draw_qr", scope: !32, file: !32, line: 287, type: !18, scopeLine: 287, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1202, keyInstructions: true)
!1202 = !{!1203, !1204, !1205, !1206}
!1203 = !DILocalVariable(name: "s", scope: !1201, file: !32, line: 288, type: !15)
!1204 = !DILocalVariable(name: "d", scope: !1201, file: !32, line: 289, type: !10)
!1205 = !DILocalVariable(name: "r", scope: !1201, file: !32, line: 290, type: !11)
!1206 = !DILocalVariable(name: "c", scope: !1201, file: !32, line: 290, type: !11)
!1207 = !DILocation(line: 0, scope: !1201)
!1208 = !DILocation(line: 295, column: 11, scope: !1201, atomGroup: 3, atomRank: 1)
!1209 = !DILocation(line: 296, column: 10, scope: !1210)
!1210 = distinct !DILexicalBlock(scope: !1201, file: !32, line: 296, column: 5)
!1211 = !DILocation(line: 288, column: 17, scope: !1201, atomGroup: 1, atomRank: 1)
!1212 = !DILocation(line: 296, scope: !1210, atomGroup: 4, atomRank: 1)
!1213 = !DILocation(line: 296, column: 19, scope: !1214, atomGroup: 5, atomRank: 1)
!1214 = distinct !DILexicalBlock(scope: !1210, file: !32, line: 296, column: 5)
!1215 = !DILocation(line: 296, column: 5, scope: !1210, atomGroup: 6, atomRank: 1)
!1216 = !DILocation(line: 297, scope: !1217, atomGroup: 7, atomRank: 1)
!1217 = distinct !DILexicalBlock(scope: !1218, file: !32, line: 297, column: 9)
!1218 = distinct !DILexicalBlock(scope: !1214, file: !32, line: 296, column: 35)
!1219 = !DILocation(line: 297, column: 23, scope: !1220, atomGroup: 8, atomRank: 1)
!1220 = distinct !DILexicalBlock(scope: !1217, file: !32, line: 297, column: 9)
!1221 = !DILocation(line: 297, column: 9, scope: !1217, atomGroup: 9, atomRank: 1)
!1222 = !DILocation(line: 298, column: 22, scope: !1220, atomGroup: 11, atomRank: 2)
!1223 = !DILocation(line: 298, column: 20, scope: !1220, atomGroup: 10, atomRank: 2)
!1224 = !DILocation(line: 298, column: 15, scope: !1220, atomGroup: 12, atomRank: 2)
!1225 = !DILocation(line: 298, column: 18, scope: !1220, atomGroup: 10, atomRank: 1)
!1226 = !DILocation(line: 297, column: 35, scope: !1220, atomGroup: 13, atomRank: 2)
!1227 = !DILocation(line: 297, column: 9, scope: !1220)
!1228 = distinct !{!1228, !1229, !1230, !204}
!1229 = !DILocation(line: 297, column: 9, scope: !1217)
!1230 = !DILocation(line: 298, column: 22, scope: !1217)
!1231 = !DILocation(line: 299, column: 11, scope: !1218, atomGroup: 15, atomRank: 2)
!1232 = !DILocation(line: 296, column: 31, scope: !1214, atomGroup: 16, atomRank: 2)
!1233 = !DILocation(line: 296, column: 5, scope: !1214)
!1234 = distinct !{!1234, !1235, !1236, !204}
!1235 = !DILocation(line: 296, column: 5, scope: !1210)
!1236 = !DILocation(line: 300, column: 5, scope: !1210)
!1237 = !DILocation(line: 301, column: 1, scope: !1201, atomGroup: 18, atomRank: 1)
!1238 = distinct !DISubprogram(name: "boot_from_floppy_or_jump_prom1", scope: !32, file: !32, line: 843, type: !18, scopeLine: 843, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1239, keyInstructions: true)
!1239 = !{!1240}
!1240 = !DILocalVariable(name: "status", scope: !1238, file: !32, line: 844, type: !11)
!1241 = !DILocation(line: 846, column: 5, scope: !1238)
!1242 = !DILocation(line: 849, column: 5, scope: !1238)
!1243 = !DILocation(line: 850, column: 26, scope: !1238)
!1244 = !DILocation(line: 850, column: 5, scope: !1238)
!1245 = !DILocation(line: 851, column: 22, scope: !1238, atomGroup: 1, atomRank: 2)
!1246 = !DILocation(line: 851, column: 20, scope: !1238, atomGroup: 1, atomRank: 1)
!1247 = !DILocation(line: 852, column: 29, scope: !1238, atomGroup: 2, atomRank: 3)
!1248 = !DILocation(line: 0, scope: !1238)
!1249 = !DILocation(line: 855, column: 5, scope: !1238)
!1250 = !DILocation(line: 856, column: 26, scope: !1238)
!1251 = !DILocation(line: 856, column: 5, scope: !1238)
!1252 = !DILocation(line: 858, column: 9, scope: !1253)
!1253 = distinct !DILexicalBlock(scope: !1238, file: !32, line: 858, column: 9)
!1254 = !DILocation(line: 858, column: 20, scope: !1253)
!1255 = !DILocation(line: 858, column: 33, scope: !1253)
!1256 = !DILocation(line: 858, column: 16, scope: !1253, atomGroup: 3, atomRank: 2)
!1257 = !DILocation(line: 858, column: 47, scope: !1253, atomGroup: 3, atomRank: 1)
!1258 = !DILocation(line: 859, column: 9, scope: !1253)
!1259 = !DILocation(line: 859, column: 31, scope: !1253, atomGroup: 4, atomRank: 2)
!1260 = !DILocation(line: 858, column: 47, scope: !1253, atomGroup: 4, atomRank: 1)
!1261 = !DILocation(line: 865, column: 22, scope: !1238, atomGroup: 6, atomRank: 1)
!1262 = !DILocation(line: 866, column: 18, scope: !1238, atomGroup: 7, atomRank: 1)
!1263 = !DILocation(line: 867, column: 20, scope: !1238, atomGroup: 8, atomRank: 1)
!1264 = !DILocation(line: 868, column: 9, scope: !1265)
!1265 = distinct !DILexicalBlock(scope: !1238, file: !32, line: 868, column: 9)
!1266 = !DILocation(line: 868, column: 46, scope: !1265, atomGroup: 9, atomRank: 2)
!1267 = !DILocation(line: 868, column: 46, scope: !1265, atomGroup: 9, atomRank: 1)
!1268 = !DILocation(line: 869, column: 25, scope: !1269, atomGroup: 10, atomRank: 1)
!1269 = distinct !DILexicalBlock(scope: !1265, file: !32, line: 868, column: 52)
!1270 = !DILocation(line: 870, column: 5, scope: !1269)
!1271 = !DILocation(line: 871, column: 18, scope: !1238, atomGroup: 11, atomRank: 1)
!1272 = !DILocation(line: 872, column: 9, scope: !1273)
!1273 = distinct !DILexicalBlock(scope: !1238, file: !32, line: 872, column: 9)
!1274 = !DILocation(line: 872, column: 46, scope: !1273, atomGroup: 12, atomRank: 2)
!1275 = !DILocation(line: 872, column: 46, scope: !1273, atomGroup: 12, atomRank: 1)
!1276 = !DILocalVariable(name: "val", arg: 1, scope: !1277, file: !6, line: 185, type: !12)
!1277 = distinct !DISubprogram(name: "port_out_ramen", scope: !6, file: !6, line: 185, type: !191, scopeLine: 185, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1278, keyInstructions: true)
!1278 = !{!1276}
!1279 = !DILocation(line: 0, scope: !1277, inlinedAt: !1280)
!1280 = distinct !DILocation(line: 877, column: 5, scope: !1238)
!1281 = !DILocation(line: 185, column: 1, scope: !1277, inlinedAt: !1280, atomGroup: 1, atomRank: 1)
!1282 = !DILocation(line: 879, column: 5, scope: !1238)
!1283 = !DILocation(line: 880, column: 45, scope: !1284)
!1284 = distinct !DILexicalBlock(scope: !1238, file: !32, line: 879, column: 15)
!1285 = !DILocation(line: 880, column: 9, scope: !1284)
!1286 = !DILocation(line: 881, column: 21, scope: !1287)
!1287 = distinct !DILexicalBlock(scope: !1284, file: !32, line: 881, column: 13)
!1288 = !DILocation(line: 881, column: 30, scope: !1287, atomGroup: 14, atomRank: 2)
!1289 = !DILocation(line: 881, column: 30, scope: !1287, atomGroup: 14, atomRank: 1)
!1290 = !DILocation(line: 884, column: 9, scope: !1284)
!1291 = distinct !{!1291, !1282, !1292}
!1292 = !DILocation(line: 885, column: 5, scope: !1238)
!1293 = !DILocation(line: 887, column: 15, scope: !1238, atomGroup: 16, atomRank: 1)
!1294 = !DILocation(line: 888, column: 5, scope: !1238)
!1295 = !DILocation(line: 889, column: 1, scope: !1238, atomGroup: 17, atomRank: 1)
!1296 = distinct !DISubprogram(name: "boot_floppy_or_prom", scope: !32, file: !32, line: 697, type: !18, scopeLine: 697, flags: DIFlagPrototyped | DIFlagNoReturn | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, keyInstructions: true)
!1297 = !DILocation(line: 698, column: 9, scope: !1298)
!1298 = distinct !DILexicalBlock(scope: !1296, file: !32, line: 698, column: 9)
!1299 = !DILocation(line: 698, column: 79, scope: !1298, atomGroup: 1, atomRank: 2)
!1300 = !DILocation(line: 698, column: 79, scope: !1298, atomGroup: 1, atomRank: 1)
!1301 = !DILocation(line: 0, scope: !1302)
!1302 = distinct !DILexicalBlock(scope: !1298, file: !32, line: 698, column: 85)
!1303 = !{!1304, !1304, i64 0}
!1304 = !{!"p1 omnipotent char", !1305, i64 0}
!1305 = !{!"any pointer", !169, i64 0}
!1306 = !DILocation(line: 700, column: 32, scope: !1302, atomGroup: 3, atomRank: 1)
!1307 = !DILocation(line: 700, column: 9, scope: !1302, atomGroup: 4, atomRank: 1)
!1308 = !DILocation(line: 701, column: 17, scope: !1309)
!1309 = distinct !DILexicalBlock(scope: !1310, file: !32, line: 701, column: 17)
!1310 = distinct !DILexicalBlock(scope: !1302, file: !32, line: 700, column: 42)
!1311 = !DILocation(line: 701, column: 27, scope: !1309, atomGroup: 5, atomRank: 2)
!1312 = !DILocation(line: 701, column: 27, scope: !1309, atomGroup: 5, atomRank: 1)
!1313 = !DILocation(line: 702, column: 26, scope: !1314, atomGroup: 6, atomRank: 2)
!1314 = distinct !DILexicalBlock(scope: !1309, file: !32, line: 701, column: 33)
!1315 = !DILocation(line: 703, column: 17, scope: !1314, atomGroup: 7, atomRank: 1)
!1316 = distinct !{!1316, !1317, !1318, !204}
!1317 = !DILocation(line: 700, column: 9, scope: !1302)
!1318 = !DILocation(line: 713, column: 9, scope: !1302)
!1319 = !DILocation(line: 705, column: 17, scope: !1320)
!1320 = distinct !DILexicalBlock(scope: !1310, file: !32, line: 705, column: 17)
!1321 = !DILocation(line: 705, column: 49, scope: !1320, atomGroup: 8, atomRank: 2)
!1322 = !DILocation(line: 705, column: 49, scope: !1320, atomGroup: 8, atomRank: 1)
!1323 = !DILocation(line: 706, column: 26, scope: !1324, atomGroup: 9, atomRank: 2)
!1324 = distinct !DILexicalBlock(scope: !1320, file: !32, line: 705, column: 55)
!1325 = !DILocation(line: 706, column: 26, scope: !1324, atomGroup: 9, atomRank: 1)
!1326 = !DILocation(line: 707, column: 21, scope: !1327)
!1327 = distinct !DILexicalBlock(scope: !1324, file: !32, line: 707, column: 21)
!1328 = !DILocation(line: 707, column: 31, scope: !1327, atomGroup: 10, atomRank: 2)
!1329 = !DILocation(line: 707, column: 36, scope: !1327, atomGroup: 10, atomRank: 1)
!1330 = !DILocation(line: 708, column: 21, scope: !1327)
!1331 = !DILocation(line: 708, column: 53, scope: !1327, atomGroup: 11, atomRank: 2)
!1332 = !DILocation(line: 707, column: 36, scope: !1327, atomGroup: 11, atomRank: 1)
!1333 = !DILocation(line: 709, column: 21, scope: !1334)
!1334 = distinct !DILexicalBlock(scope: !1327, file: !32, line: 708, column: 59)
!1335 = !DILocation(line: 710, column: 17, scope: !1334)
!1336 = !DILocation(line: 714, column: 9, scope: !1337, atomGroup: 13, atomRank: 1)
!1337 = distinct !DILexicalBlock(scope: !1302, file: !32, line: 714, column: 9)
!1338 = !DILocation(line: 714, column: 9, scope: !1337)
!1339 = !DILocation(line: 717, column: 9, scope: !1340)
!1340 = distinct !DILexicalBlock(scope: !1296, file: !32, line: 717, column: 9)
!1341 = !DILocation(line: 717, column: 80, scope: !1340, atomGroup: 14, atomRank: 2)
!1342 = !DILocation(line: 717, column: 80, scope: !1340, atomGroup: 14, atomRank: 1)
!1343 = !DILocation(line: 718, column: 17, scope: !1344)
!1344 = distinct !DILexicalBlock(scope: !1340, file: !32, line: 717, column: 86)
!1345 = !DILocation(line: 718, column: 9, scope: !1344)
!1346 = !DILocation(line: 719, column: 5, scope: !1344)
!1347 = !DILocation(line: 730, column: 5, scope: !1348, atomGroup: 15, atomRank: 1)
!1348 = distinct !DILexicalBlock(scope: !1296, file: !32, line: 730, column: 5)
!1349 = !DILocation(line: 730, column: 5, scope: !1348)
