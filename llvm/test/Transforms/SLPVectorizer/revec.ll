; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer -S -slp-revec -slp-max-reg-size=1024 -slp-threshold=-100 %s | FileCheck %s

define void @test1(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <16 x i32>, ptr [[A:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <16 x i32>, ptr [[B:%.*]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = add <16 x i32> [[TMP1]], [[TMP0]]
; CHECK-NEXT:    store <16 x i32> [[TMP2]], ptr [[C:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx3 = getelementptr inbounds i32, ptr %a, i64 4
  %arrayidx7 = getelementptr inbounds i32, ptr %a, i64 8
  %arrayidx11 = getelementptr inbounds i32, ptr %a, i64 12
  %0 = load <4 x i32>, ptr %a, align 4
  %1 = load <4 x i32>, ptr %arrayidx3, align 4
  %2 = load <4 x i32>, ptr %arrayidx7, align 4
  %3 = load <4 x i32>, ptr %arrayidx11, align 4
  %arrayidx19 = getelementptr inbounds i32, ptr %b, i64 4
  %arrayidx23 = getelementptr inbounds i32, ptr %b, i64 8
  %arrayidx27 = getelementptr inbounds i32, ptr %b, i64 12
  %4 = load <4 x i32>, ptr %b, align 4
  %5 = load <4 x i32>, ptr %arrayidx19, align 4
  %6 = load <4 x i32>, ptr %arrayidx23, align 4
  %7 = load <4 x i32>, ptr %arrayidx27, align 4
  %add.i = add <4 x i32> %4, %0
  %add.i63 = add <4 x i32> %5, %1
  %add.i64 = add <4 x i32> %6, %2
  %add.i65 = add <4 x i32> %7, %3
  %arrayidx36 = getelementptr inbounds i32, ptr %c, i64 4
  %arrayidx39 = getelementptr inbounds i32, ptr %c, i64 8
  %arrayidx42 = getelementptr inbounds i32, ptr %c, i64 12
  store <4 x i32> %add.i, ptr %c, align 4
  store <4 x i32> %add.i63, ptr %arrayidx36, align 4
  store <4 x i32> %add.i64, ptr %arrayidx39, align 4
  store <4 x i32> %add.i65, ptr %arrayidx42, align 4
  ret void
}

define void @test2(ptr %in, ptr %out) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <16 x i16>, ptr [[IN:%.*]], align 2
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.sadd.sat.v16i16(<16 x i16> [[TMP0]], <16 x i16> [[TMP0]])
; CHECK-NEXT:    store <16 x i16> [[TMP1]], ptr [[OUT:%.*]], align 2
; CHECK-NEXT:    ret void
;
entry:
  %0 = getelementptr i16, ptr %in, i64 8
  %1 = load <8 x i16>, ptr %in, align 2
  %2 = load <8 x i16>, ptr %0, align 2
  %3 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %1, <8 x i16> %1)
  %4 = call <8 x i16> @llvm.sadd.sat.v8i16(<8 x i16> %2, <8 x i16> %2)
  %5 = getelementptr i16, ptr %out, i64 8
  store <8 x i16> %3, ptr %out, align 2
  store <8 x i16> %4, ptr %5, align 2
  ret void
}

define void @test3(ptr %x, ptr %y, ptr %z) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x ptr> poison, ptr [[X:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x ptr> [[TMP0]], ptr [[Y:%.*]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <2 x ptr> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = load <8 x i32>, ptr [[X]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = load <8 x i32>, ptr [[Y]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <2 x i1> [[TMP2]], <2 x i1> poison, <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP6:%.*]] = select <8 x i1> [[TMP5]], <8 x i32> [[TMP3]], <8 x i32> [[TMP4]]
; CHECK-NEXT:    store <8 x i32> [[TMP6]], ptr [[Z:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = getelementptr inbounds i32, ptr %x, i64 4
  %1 = getelementptr inbounds i32, ptr %y, i64 4
  %2 = load <4 x i32>, ptr %x, align 4
  %3 = load <4 x i32>, ptr %0, align 4
  %4 = load <4 x i32>, ptr %y, align 4
  %5 = load <4 x i32>, ptr %1, align 4
  %6 = icmp eq ptr %x, null
  %7 = icmp eq ptr %y, null
  %8 = select i1 %6, <4 x i32> %2, <4 x i32> %4
  %9 = select i1 %7, <4 x i32> %3, <4 x i32> %5
  %10 = getelementptr inbounds i32, ptr %z, i64 4
  store <4 x i32> %8, ptr %z, align 4
  store <4 x i32> %9, ptr %10, align 4
  ret void
}

define void @test4(ptr %in, ptr %out) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <8 x float>, ptr [[IN:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x float> @llvm.vector.insert.v16f32.v8f32(<16 x float> poison, <8 x float> poison, i64 8)
; CHECK-NEXT:    [[TMP2:%.*]] = call <16 x float> @llvm.vector.insert.v16f32.v8f32(<16 x float> [[TMP1]], <8 x float> [[TMP0]], i64 0)
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <16 x float> [[TMP2]], <16 x float> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP4:%.*]] = call <16 x float> @llvm.vector.insert.v16f32.v8f32(<16 x float> poison, <8 x float> zeroinitializer, i64 0)
; CHECK-NEXT:    [[TMP5:%.*]] = call <16 x float> @llvm.vector.insert.v16f32.v8f32(<16 x float> [[TMP4]], <8 x float> zeroinitializer, i64 8)
; CHECK-NEXT:    [[TMP6:%.*]] = fmul <16 x float> [[TMP3]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = call <16 x float> @llvm.vector.insert.v16f32.v8f32(<16 x float> poison, <8 x float> poison, i64 0)
; CHECK-NEXT:    [[TMP8:%.*]] = call <16 x float> @llvm.vector.insert.v16f32.v8f32(<16 x float> [[TMP7]], <8 x float> zeroinitializer, i64 8)
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <16 x float> [[TMP2]], <16 x float> [[TMP8]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP10:%.*]] = fadd <16 x float> [[TMP9]], [[TMP6]]
; CHECK-NEXT:    [[TMP11:%.*]] = fcmp ogt <16 x float> [[TMP10]], [[TMP5]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr i1, ptr [[OUT:%.*]], i64 8
; CHECK-NEXT:    [[TMP13:%.*]] = call <8 x i1> @llvm.vector.extract.v8i1.v16i1(<16 x i1> [[TMP11]], i64 8)
; CHECK-NEXT:    store <8 x i1> [[TMP13]], ptr [[OUT]], align 1
; CHECK-NEXT:    [[TMP14:%.*]] = call <8 x i1> @llvm.vector.extract.v8i1.v16i1(<16 x i1> [[TMP11]], i64 0)
; CHECK-NEXT:    store <8 x i1> [[TMP14]], ptr [[TMP12]], align 1
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <8 x float>, ptr %in, align 4
  %1 = fmul <8 x float> %0, zeroinitializer
  %2 = fmul <8 x float> %0, zeroinitializer
  %3 = fadd <8 x float> zeroinitializer, %1
  %4 = fadd <8 x float> %0, %2
  %5 = fcmp ogt <8 x float> %3, zeroinitializer
  %6 = fcmp ogt <8 x float> %4, zeroinitializer
  %7 = getelementptr i1, ptr %out, i64 8
  store <8 x i1> %5, ptr %out, align 1
  store <8 x i1> %6, ptr %7, align 1
  ret void
}
