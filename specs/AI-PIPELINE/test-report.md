# Báo cáo kiểm thử: AI-PIPELINE (S1-S5, T1-T10) — Vòng 1
Kết luận: PASS (tự động hóa 36/37 AC; AC-30 cần benchmark thủ công)

Full suite `mvnw -B verify`: Tests run 307, Failures 0, Errors 0, Skipped 0, BUILD SUCCESS (Postgres 5433, STT/LLM/S3 đều mock).

## Ma trận AC -> test
(Lớp thuộc package com.example.interviewpractice; "PS" = controller.PracticeSession)
| AC | Test | KQ |
|---|---|---|
| 1 | PSCreateIntegrationTest.createsSessionInCreatedStatusForActiveQuestion | PASS |
| 2 | PSCreateIntegrationTest.unknownQuestionGets404 / hiddenQuestionGets404 | PASS |
| 3 | PSCreateIntegrationTest.requestsWithoutTokenGet401; PSEvaluateIntegrationTest.withoutTokenIsRejected; PSResultIntegrationTest.withoutTokenGets401 | PASS |
| 4 | PSUploadIntegrationTest.validUploadMovesToUploadedAndStoresKeyAndDuration, codecParameterInContentTypeIsAccepted | PASS |
| 5 | PSUploadIntegrationTest.durationOutsideRangeGets400AndKeepsStatus (9, 181), durationBoundariesAreAccepted (10, 180), unsupportedMimeOrExtensionOrEmptyFileGets400, missingDurationGets400, fileLargerThanLimitGets400 | PASS |
| 6 | PSUploadIntegrationTest.unknownSessionGets404 | PASS |
| 7 | PSAccessIntegrationTest.getSessionOfAnotherUserGets403 (+ upload 403 giữ status) | PASS |
| 8 | PSCreateIntegrationTest.getReturnsOwnSessionWithValidStatus; PSAccessIntegrationTest.getUnknownSessionGets404 | PASS |
| 9 | GeminiSttClientTest.firstTimeoutThenSuccessMakesExactlyTwoRequests; ConfigPropertiesTest (timeout 15s) | PASS |
| 10 | EvaluationPipelineIntegrationTest.sttFailureMarksFailedSttError, audioReadFailureMarksFailedSttError; GeminiSttClientTest.twoFailuresThrowSttException... | PASS |
| 11 | GeminiSttClientTest.successKeepsFillerWordsAndSendsVerbatimPromptAndAudio | PASS |
| 12 | EvaluationPipelineIntegrationTest.fourteenWordsFailsAnswerTooShortWithoutCallingLlm / fifteenWordsIsScored | PASS |
| 13 | DeliveryCalculatorTest$DiemTocDo, $TachTu | PASS |
| 14 | DeliveryCalculatorTest$DiemTuDem, $TinhTongHop | PASS |
| 15 | DeliveryCalculatorTest$DemTuDem (lặp từ, không đếm "thì/là/mà"); DeliveryIntegrationTest | PASS |
| 16 | DeliveryCalculatorTest$KhongDuDuLieu; ScoreCalculatorTest.thieuDeliveryThiChiaLaiTrongSoTheoMuoiPhanChin | PASS |
| 17 | RubricConfigTest (4 loại, tongTrongSoCongDeliveryBang100, chiTechnicalCoCorrectness) | PASS |
| 18 | ScoreCalculatorTest.viDuOpenApiChoDiem57Phay5VaContent55Phay6; LlmResultValidatorTest.totalScoreCuaLlmBiBoQua; InjectionHandlingTest (totalScore=100 bị bỏ qua) | PASS |
| 19 | ScoreCalculatorTest.contentScoreChiGomTieuChiLlmNenKhongDoiKhiDeliveryDoi | PASS |
| 20 | ScoreCalculatorTest.offTopicChanTai30ChiKhiTrenNguong, offTopicKhongLamDoiContentScore; **MỚI** EvaluationPipelineIntegrationTest.offTopicResultCapsStoredTotalScoreAt30 (end-to-end, DB) | PASS |
| 21 | GeminiLlmClientTest.guiJsonMimeTypeNhietDoThapSchemaVaKhoaQuaHeader (temp 0.2); LlmScorerTest.thanhCongLanDauChiGoiMotLan | PASS |
| 22 | PSResultIntegrationTest.sessionScoredGets200WithVersionsTranscriptAndPerCriterionDetails; ScoreResultWriterTest.saveStores... | PASS |
| 23 | PSResultIntegrationTest.sessionNotScoredGets409SessionNotReady, resultOfAnotherUserGets403, unknownSessionGets404 | PASS |
| 24 | PSEvaluateIntegrationTest.uploadedSessionGets202ProcessingAndOneJob, failedSessionCanBeEvaluatedAgain...; **MỚI** evaluateRespondsWithin1Second | PASS |
| 25 | PSEvaluateIntegrationTest.createdSessionWithoutAudioGets409, processingSessionGets409AndNoSecondJob, scoredSessionGets409AlreadyScored; EvaluateConcurrencyTest.parallelEvaluateStartsExactlyOneJob | PASS |
| 26 | EvaluationAsyncIntegrationTest.realExecutorEventuallyScoresSession; EvaluationPipelineIntegrationTest.successScoresSession... | PASS |
| 27 | LlmScorerTest.loiGoiRoiThanhCong..., loiGoiHaiLanThiLlmError...; EvaluationPipelineIntegrationTest.llmErrorTwice..., invalidResultTwice..., llmFailsOnceThenSucceeds...; OneRetryTest | PASS |
| 28 | PSEvaluateIntegrationTest.failedSessionCanBeEvaluatedAgain...; EvaluationPipelineIntegrationTest.unexpectedErrorStillEndsFailed...; ScoreResultWriterTest.rescoreOverwrites... | PASS |
| 29 | SessionRecoveryRunnerTest.staleProcessingBecomesFailedServerRestart, processingStartedAfterBoot...; EvaluationPipelineIntegrationTest.sessionFailedByRestartMidScoring... | PASS |
| 30 | KHÔNG TỰ ĐỘNG HÓA (xem dưới) | N/A |
| 31 | PromptBuilderTest.transcriptDuocBocTrongTheVaSystemPromptNoiRoLaLoiThiSinh, theDongTrongTranscriptBiVoHieuHoa | PASS |
| 32 | InjectionHandlingTest.injectionSuspectedVanChamLuuCoVaGhiWarnKhongLoTranscript | PASS |
| 33 | LlmResultValidatorTest.diemNgoaiKhoangHoacKhongNguyenLaSaiSchema; ScoreCalculatorTest.diemNgoaiKhoang1Den5ThiNemLoi | PASS |
| 34 | QuoteValidatorTest; LlmScorerTest.motTrenBaQuoteSaiKhongRetryVaTieuChiBiHaVeHai; InjectionHandlingTest.quoteBiaBiHaVeHaiVaLuuQuoteInvalid | PASS |
| 35 | LlmScorerTest.quaNuaQuoteSaiRetryDungMotLanRoiThanhCong, quaNuaQuoteSaiHaiLan..., dungMotNuaQuoteSaiBonTieuChiKhongRetry | PASS |
| 36 | LlmResultValidatorTest.technicalThieuCorrectnessLaSaiSchema, behavioralCoThemCorrectnessLaSaiSchema; ScoreCalculatorTest.thieuHoacThuaTieuChiThiNemLoi | PASS |
| 37 | PromptBuilderTest.chiNhoiDuLieuCauHoiHienTaiVaDapAnThamChieuKhiCo, userPromptChiCoDuLieuTruyenVaoKhongCoDinhDanhNguoiDung | PASS |

## Mục tập trung theo yêu cầu
- offTopic: trước chỉ có assert prompt + unit ScoreCalculator; đã thêm test e2e (AC-20).
- Upload lại: PSUploadIntegrationTest.reUploadIsAllowedWhenUploadedOrFailed; từ chối khi PROCESSING/SCORED (409, không gọi storage) — đủ.
- 403 vs 404: có cặp test cho GET, upload, evaluate, result (PSAccessIntegrationTest, PSEvaluateIntegrationTest.otherUsersSessionGets403AndStaysUploaded/unknownSessionGets404, PSResultIntegrationTest) — đủ.
- Hồi quy /auth và /questions: AuthServiceTest, AuthRegisterIntegrationTest, AuthLoginConcurrencyTest, JwtAuthenticationFilterTest, QuestionApiIntegrationTest, QuestionControllerTest, QuestionServiceTest, DbConstraintsTest đều PASS trong full suite; không thêm test.

## Lỗi phát hiện
Không có (không CODE_BUG, không PRE_EXISTING).

## AC không thể tự động hóa
- AC-30 (<=12s từ upload đến SCORED, 14 mẫu 10-131s): cần audio và key Gemini/FPT thật.
  Benchmark thủ công: (1) chạy backend với key thật + S3 thật; (2) với mỗi mẫu: POST /practice-sessions, POST /answer (ghi t0), POST /evaluate, poll GET /practice-sessions/{id} mỗi 500ms đến SCORED/FAILED (ghi t1); (3) ghi t1-t0 từng mẫu, yêu cầu max <=12s (khuyến nghị xem p95), kèm tỷ lệ FAILED; (4) tách thời gian STT và LLM từ log/ApiUsage nếu vượt ngưỡng.
- AC-24 chỉ đo phần đồng bộ của endpoint khi worker bị mock (đủ cho yêu cầu 202 <=1s). AC-9 timeout 15s được kiểm bằng cấu hình + mô phỏng SocketTimeoutException, không chờ 15s thật.

## Test thêm vòng này
- EvaluationPipelineIntegrationTest.offTopicResultCapsStoredTotalScoreAt30
- PracticeSessionEvaluateIntegrationTest.evaluateRespondsWithin1Second (ngưỡng 1000ms có thể flaky trên máy rất chậm; chạy 1 lần đạt)

## Lệnh đã chạy
`cmd /c .\mvnw.cmd -B verify` trong backend (env theo yêu cầu): 307 tests, 0 fail, BUILD SUCCESS.

## Ghi chú
Không đọc .env, không gọi dịch vụ thật, không sửa code production, không commit/push.
