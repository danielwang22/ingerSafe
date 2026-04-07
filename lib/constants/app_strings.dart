/// 應用程式多語言文字常數
class AppStrings {
  /// AI 分析提示詞
  static const String _riskLevelInstruction = """
CRITICAL: Line 1 must be exactly one tag, no other text:
[RISK_LEVEL:low] [RISK_LEVEL:medium] [RISK_LEVEL:high]
low=safe|medium=caution|high=avoid. Analysis on line 2.
IMAGE FIRST: Image is primary. Ignore user text if wrong, irrelevant, or random.
NON-FOOD: If no human-edible food visible, reply ONLY [RISK_LEVEL:unknown] then non-food phrase. Nothing else.
""";

  static final Map<String, String> prompts = {
    'en': """
$_riskLevelInstruction
Health analysis assistant for pregnant/breastfeeding women. Analyze visible ingredients from the image and explain risks.
State overall risk first. Group under **⚠ Primary Risks** (high-risk) and **ℹ Secondary Concerns** (low-risk). Format each: - **Item** – brief effect.
Respond in English. No invented info. No unverified advice.
Non-food: [RISK_LEVEL:unknown]\nNot a food item
""",
    'zh_Hant': """
$_riskLevelInstruction
專為孕婦/哺乳婦女服務的健康分析助手。分析圖片中可識別的成分，說明對孕婦/哺乳婦的負面影響。
先說明整體危險性，高風險物質列於 **⚠ 主要風險** 標題下，低風險物質列於 **ℹ 次要風險** 標題下。格式：- **物質** – 影響說明。
以繁體中文回應。勿虛構資訊，勿給未驗證建議。
非食品：[RISK_LEVEL:unknown]\n非可食品
""",
    'ja': """
$_riskLevelInstruction
妊娠中・授乳中の女性向け健康分析アシスタント。画像から識別可能な成分を分析しリスクを説明する。
全体的な危険性を先に述べ、高リスク物質は **⚠ 主なリスク** 、低リスク物質は **ℹ 軽微な懸念** の見出しの下に列挙。形式：- **物質名** – 影響の説明。
日本語で回答。情報の捏造禁止。未検証のアドバイス禁止。
食品でない場合：[RISK_LEVEL:unknown]\n食品ではありません
""",
    'ko': """
$_riskLevelInstruction
임산부/수유 중인 여성 대상 건강 분석 도우미입니다. 이미지에서 식별 가능한 성분을 분석하고 위험성을 설명하세요.
전체 위험도 먼저 명시. 고위험 항목은 **⚠ 주요 위험** , 저위험 항목은 **ℹ 경미한 우려** 제목 아래 나열. 형식: - **물질** – 영향 설명.
한국어로 응답. 정보 조작 금지. 미검증 조언 금지.
식품 아닌 경우: [RISK_LEVEL:unknown]\n식품이 아닙니다
""",
    'th': """
$_riskLevelInstruction
ผู้ช่วยวิเคราะห์สุขภาพสำหรับหญิงตั้งครรภ์/ให้นมบุตร วิเคราะห์ส่วนผสมที่อ่านได้จากภาพและอธิบายความเสี่ยง
ระบุความเสี่ยงโดยรวมก่อน สารเสี่ยงสูงอยู่ใต้หัวข้อ **⚠ ความเสี่ยงหลัก** สารเสี่ยงต่ำอยู่ใต้หัวข้อ **ℹ ความกังวลรอง** รูปแบบ: - **สาร** – คำอธิบาย
ตอบเป็นภาษาไทย ห้ามแต่งข้อมูล ห้ามคำแนะนำไม่ได้รับการยืนยัน
ไม่ใช่อาหาร: [RISK_LEVEL:unknown]\nไม่ใช่อาหาร
""",
    'vi': """
$_riskLevelInstruction
Trợ lý phân tích sức khỏe cho phụ nữ mang thai/đang cho con bú. Phân tích thành phần nhận diện được từ ảnh và giải thích rủi ro.
Nêu mức nguy hiểm tổng thể trước. Chất nguy cơ cao dưới tiêu đề **⚠ Rủi ro chính** , chất nguy cơ thấp dưới **ℹ Mối lo phụ** . Định dạng: - **Chất** – giải thích tác động.
Trả lời bằng tiếng Việt. Không bịa thông tin. Không tư vấn chưa kiểm chứng.
Không phải thực phẩm: [RISK_LEVEL:unknown]\nKhông phải thực phẩm
""",
  };

  static final Map<String, String> imagePrompts = {
    'en':
        'Please analyze whether this food product may have potential negative effects on pregnant or breastfeeding women.',
    'zh_Hant': '請分析此食物食品，是否對懷孕或哺乳女性可能產生的負面影響。',
    'ja': 'この食品が妊娠中または授乳中の女性に悪影響を及ぼす可能性があるかどうかを分析してください。',
    'ko': '이 식품이 임산부 또는 수유 중인 여성에게 부정적인 영향을 줄 가능성이 있는지 분석해 주세요.',
    'th':
        'โปรดวิเคราะห์ว่าอาหาร/ผลิตภัณฑ์นี้อาจส่งผลเสียต่อหญิงตั้งครรภ์หรือให้นมบุตรหรือไม่',
    'vi':
        'Vui lòng phân tích xem thực phẩm/sản phẩm này có thể gây ảnh hưởng tiêu cực đến phụ nữ mang thai hoặc đang cho con bú hay không.',
  };

  static final Map<String, String> userNotePrefix = {
    'en': 'Additional information from the user: ',
    'zh_Hant': '使用者補充說明：',
    'ja': 'ユーザーからの補足情報：',
    'ko': '사용자 추가 설명: ',
    'th': 'ข้อมูลเพิ่มเติมจากผู้ใช้: ',
    'vi': 'Thông tin bổ sung từ người dùng: ',
  };

  /// ===== v2.0 i18n 文字常數 =====

  /// 報告詳情頁
  static final Map<String, Map<String, String>> reportDetailTexts = {
    'en': {
      'riskLow': 'Safe — Generally safe to consume',
      'riskMedium': 'Caution — Consume with care',
      'riskHigh': 'Avoid — Not recommended during pregnancy',
      'riskUnknown': 'Uncertain — Unable to Determine',
      'safetyReport': 'Safety Report',
      'references': 'References',
      'disclaimer':
          '⚠️ This report is for reference only and does not constitute medical advice. Consult a professional doctor if in doubt.',
      'reanalyze': 'Re-analyze',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'confirmDeleteMessage': 'Are you sure you want to delete this report?',
      'analyzing': 'Analyzing… Please wait',
      'analysisFailed': 'Analysis failed: ',
    },
    'zh_Hant': {
      'riskLow': '安全 — 一般可安心食用',
      'riskMedium': '注意 — 建議謹慎食用',
      'riskHigh': '避免 — 建議孕期迴避',
      'riskUnknown': '不確定 — 無法判斷',
      'safetyReport': '安全報告',
      'references': '參考文獻',
      'disclaimer': '⚠️ 本報告僅供參考，不構成醫療建議。如有疑問請諮詢專業醫師。',
      'reanalyze': '重新分析',
      'delete': '刪除',
      'cancel': '取消',
      'confirmDeleteMessage': '確定要刪除這份報告嗎？',
      'analyzing': '分析中…請稍候',
      'analysisFailed': '分析失敗：',
    },
    'ja': {
      'riskLow': '安全 — 一般的に安全',
      'riskMedium': '注意 — 注意して摄取することを推奨',
      'riskHigh': '控える — 妊娠中は控えることを推奨',
      'riskUnknown': '不明 — 判断不可',
      'safetyReport': '安全レポート',
      'references': '参考文献',
      'disclaimer':
          '⚠️ 本レポートは参考用であり、医療上のアドバイスを構成するものではありません。疑問がある場合は専門医にご相談ください。',
      'reanalyze': '再分析',
      'delete': '削除',
      'cancel': 'キャンセル',
      'confirmDeleteMessage': 'このレポートを削除してもよろしいですか？',
      'analyzing': '分析中…お待ちください',
      'analysisFailed': '分析に失敗しました：',
    },
    'ko': {
      'riskLow': '안전 — 일반적으로 안전',
      'riskMedium': '주의 — 주의하여 섭취 권장',
      'riskHigh': '삼가세요 — 임신 중 권장하지 않음',
      'riskUnknown': '불확실 — 판단 불가',
      'safetyReport': '안전 보고서',
      'references': '참고 문헌',
      'disclaimer': '⚠️ 이 보고서는 참고용이며 의료 조언을 구성하지 않습니다. 의문이 있으시면 전문 의사와 상담하세요.',
      'reanalyze': '재분석',
      'delete': '삭제',
      'cancel': '취소',
      'confirmDeleteMessage': '이 보고서를 삭제하시겠습니까？',
      'analyzing': '분석 중… 잠시만 기다려 주세요',
      'analysisFailed': '분석 실패: ',
    },
    'th': {
      'riskLow': 'ปลอดภัย — ปลอดภัยโดยทั่วไป',
      'riskMedium': 'ระวัง — ควรรับประทานด้วยความระมัดระวัง',
      'riskHigh': 'หลีกเลี่ยง — ไม่แนะนำในระหว่างตั้งครรภ์',
      'riskUnknown': 'ไม่แน่ใจ — ไม่สามารถระบุได้',
      'safetyReport': 'รายงานความปลอดภัย',
      'references': 'เอกสารอ้างอิง',
      'disclaimer':
          '⚠️ รายงานนี้เป็นข้อมูลอ้างอิงเท่านั้น ไม่ถือเป็นคำแนะนำทางการแพทย์ หากมีข้อสงสัย กรุณาปรึกษาแพทย์ผู้เชี่ยวชาญ',
      'reanalyze': 'วิเคราะห์อีกครั้ง',
      'delete': 'ลบ',
      'cancel': 'ยกเลิก',
      'confirmDeleteMessage': 'คุณแน่ใจหรือไม่ว่าต้องการลบรายงานนี้？',
      'analyzing': 'กำลังวิเคราะห์… กรุณารอสักครู่',
      'analysisFailed': 'วิเคราะห์ไม่สำเร็จ: ',
    },
    'vi': {
      'riskLow': 'An toàn — Nhìn chung an toàn',
      'riskMedium': 'Thận trọng — Nên thận trọng khi sử dụng',
      'riskHigh': 'Tránh — Không khuyến nghị khi mang thai',
      'riskUnknown': 'Không chắc chắn — Không thể xác định',
      'safetyReport': 'Báo cáo an toàn',
      'references': 'Tài liệu tham khảo',
      'disclaimer':
          '⚠️ Báo cáo này chỉ mang tính tham khảo, không cấu thành lời khuyên y tế. Nếu có thắc mắc, vui lòng tham khảo ý kiến bác sĩ chuyên môn.',
      'reanalyze': 'Phân tích lại',
      'delete': 'Xóa',
      'cancel': 'Hủy',
      'confirmDeleteMessage': 'Bạn có chắc muốn xóa báo cáo này không?',
      'analyzing': 'Đang phân tích… Vui lòng đợi',
      'analysisFailed': 'Phân tích thất bại: ',
    },
  };

  /// 報告列表頁
  static final Map<String, Map<String, String>> reportsScreenTexts = {
    'en': {
      'analyzing': 'Analyzing… Please wait',
      'analysisFailed': 'Analysis failed: ',
      'analysisTimeout': 'Analysis timed out. Please try again.',
      'analysisError': 'An error occurred during analysis. Please try again.',
      'aiAnalyzing': 'AI Analyzing...',
      'appSubtitle': 'Pregnancy Diet Safety',
      'noReports': 'No analysis reports yet',
      'noReportsHint': 'Take or upload a food photo to start',
      'yearSuffix': '',
      'month01': 'January',
      'month02': 'February',
      'month03': 'March',
      'month04': 'April',
      'month05': 'May',
      'month06': 'June',
      'month07': 'July',
      'month08': 'August',
      'month09': 'September',
      'month10': 'October',
      'month11': 'November',
      'month12': 'December',
    },
    'zh_Hant': {
      'analyzing': '分析中…請稍候',
      'analysisFailed': '分析失敗：',
      'analysisTimeout': '分析逾時，請再試一次。',
      'analysisError': '分析時發生錯誤，請再試一次。',
      'aiAnalyzing': 'AI 分析中...',
      'appSubtitle': '孕期飲食安全',
      'noReports': '還沒有任何分析報告',
      'noReportsHint': '拍攝或上傳食物照片開始分析',
      'yearSuffix': ' 年',
      'month01': '一月',
      'month02': '二月',
      'month03': '三月',
      'month04': '四月',
      'month05': '五月',
      'month06': '六月',
      'month07': '七月',
      'month08': '八月',
      'month09': '九月',
      'month10': '十月',
      'month11': '十一月',
      'month12': '十二月',
    },
    'ja': {
      'analyzing': '分析中…お待ちください',
      'analysisFailed': '分析に失敗しました：',
      'analysisTimeout': '分析がタイムアウトしました。もう一度お試しください。',
      'analysisError': '分析中にエラーが発生しました。もう一度お試しください。',
      'aiAnalyzing': 'AI 分析中...',
      'appSubtitle': '妊娠中の食事安全',
      'noReports': '分析レポートはまだありません',
      'noReportsHint': '食べ物の写真を撮るかアップロードして開始',
      'yearSuffix': '年',
      'month01': '1月',
      'month02': '2月',
      'month03': '3月',
      'month04': '4月',
      'month05': '5月',
      'month06': '6月',
      'month07': '7月',
      'month08': '8月',
      'month09': '9月',
      'month10': '10月',
      'month11': '11月',
      'month12': '12月',
    },
    'ko': {
      'analyzing': '분석 중… 잠시만 기다려 주세요',
      'analysisFailed': '분석 실패: ',
      'analysisTimeout': '분석 시간이 초과되었습니다. 다시 시도해 주세요.',
      'analysisError': '분석 중 오류가 발생했습니다. 다시 시도해 주세요.',
      'aiAnalyzing': 'AI 분석 중...',
      'appSubtitle': '임신 중 식이 안전',
      'noReports': '아직 분석 보고서가 없습니다',
      'noReportsHint': '음식 사진을 촬영하거나 업로드하여 시작하세요',
      'yearSuffix': '년',
      'month01': '1월',
      'month02': '2월',
      'month03': '3월',
      'month04': '4월',
      'month05': '5월',
      'month06': '6월',
      'month07': '7월',
      'month08': '8월',
      'month09': '9월',
      'month10': '10월',
      'month11': '11월',
      'month12': '12월',
    },
    'th': {
      'analyzing': 'กำลังวิเคราะห์… กรุณารอสักครู่',
      'analysisFailed': 'วิเคราะห์ไม่สำเร็จ: ',
      'analysisTimeout': 'หมดเวลาวิเคราะห์ กรุณาลองใหม่',
      'analysisError': 'เกิดข้อผิดพลาด กรุณาลองใหม่',
      'aiAnalyzing': 'AI วิเคราะห์...',
      'appSubtitle': 'อาหารปลอดภัยคนท้อง',
      'noReports': 'ยังไม่มีรายงาน',
      'noReportsHint': 'ถ่ายหรืออัปโหลดรูปอาหาร',
      'yearSuffix': '',
      'month01': 'มกราคม',
      'month02': 'กุมภาพันธ์',
      'month03': 'มีนาคม',
      'month04': 'เมษายน',
      'month05': 'พฤษภาคม',
      'month06': 'มิถุนายน',
      'month07': 'กรกฎาคม',
      'month08': 'สิงหาคม',
      'month09': 'กันยายน',
      'month10': 'ตุลาคม',
      'month11': 'พฤศจิกายน',
      'month12': 'ธันวาคม',
    },
    'vi': {
      'analyzing': 'Đang phân tích… Vui lòng đợi',
      'analysisFailed': 'Phân tích thất bại: ',
      'analysisTimeout': 'Phân tích hết thời gian. Vui lòng thử lại.',
      'analysisError': 'Đã xảy ra lỗi. Vui lòng thử lại.',
      'aiAnalyzing': 'AI đang phân tích...',
      'appSubtitle': 'An toàn thực phẩm thai kỳ',
      'noReports': 'Chưa có báo cáo phân tích nào',
      'noReportsHint': 'Chụp hoặc tải ảnh thực phẩm để bắt đầu',
      'yearSuffix': '',
      'month01': 'Tháng 1',
      'month02': 'Tháng 2',
      'month03': 'Tháng 3',
      'month04': 'Tháng 4',
      'month05': 'Tháng 5',
      'month06': 'Tháng 6',
      'month07': 'Tháng 7',
      'month08': 'Tháng 8',
      'month09': 'Tháng 9',
      'month10': 'Tháng 10',
      'month11': 'Tháng 11',
      'month12': 'Tháng 12',
    },
  };

  /// 上傳對話框
  static final Map<String, Map<String, String>> uploadDialogTexts = {
    'en': {
      'defaultTitle': 'Untitled Report',
      'dialogTitle': 'New Diet Record',
      'dialogDescription':
          'Upload food photos and add a description. AI will analyze dietary safety for you.',
      'foodPhotos': 'Food Photos',
      'add': 'Add',
      'titleLabel': 'Title',
      'titleHint': 'e.g. Lunch box',
      'descriptionLabel': 'Description (optional)',
      'descriptionHint':
          'Add details about the food, ingredients, or any questions…',
      'cancel': 'Cancel',
      'startAnalysis': 'Start Analysis',
      'alertTitle': 'Missing Information',
      'alertMessage':
          'Please add at least a photo or a description before submitting.',
      'alertConfirm': 'OK',
    },
    'zh_Hant': {
      'defaultTitle': '未命名報告',
      'dialogTitle': '新增飲食紀錄',
      'dialogDescription': '上傳食物照片並新增說明，AI 將為您分析飲食安全',
      'foodPhotos': '食物照片',
      'add': '新增',
      'titleLabel': '標題',
      'titleHint': '例如：午餐便當',
      'descriptionLabel': '說明（選填）',
      'descriptionHint': '補充說明食物內容、食材或任何想了解的問題…',
      'cancel': '取消',
      'startAnalysis': '開始分析',
      'alertTitle': '資訊不完整',
      'alertMessage': '請至少新增一張照片或填寫說明後再送出。',
      'alertConfirm': '確定',
    },
    'ja': {
      'defaultTitle': '無題のレポート',
      'dialogTitle': '新しい食事記録',
      'dialogDescription': '食べ物の写真をアップロードし説明を追加すると、AIが食事の安全性を分析します',
      'foodPhotos': '食べ物の写真',
      'add': '追加',
      'titleLabel': 'タイトル',
      'titleHint': '例：ランチ弁当',
      'descriptionLabel': '説明（任意）',
      'descriptionHint': '食べ物の内容や食材、知りたいことを補足…',
      'cancel': 'キャンセル',
      'startAnalysis': '分析開始',
      'alertTitle': '情報が不足しています',
      'alertMessage': '送信する前に、写真または説明を少なくとも一つ追加してください。',
      'alertConfirm': 'OK',
    },
    'ko': {
      'defaultTitle': '제목 없는 보고서',
      'dialogTitle': '새 식사 기록',
      'dialogDescription': '음식 사진을 업로드하고 설명을 추가하면 AI가 식이 안전성을 분석합니다',
      'foodPhotos': '음식 사진',
      'add': '추가',
      'titleLabel': '제목',
      'titleHint': '예: 점심 도시락',
      'descriptionLabel': '설명 (선택 사항)',
      'descriptionHint': '음식 내용, 재료 또는 궁금한 점을 보충 설명…',
      'cancel': '취소',
      'startAnalysis': '분석 시작',
      'alertTitle': '정보가 부족합니다',
      'alertMessage': '제출하기 전에 사진 또는 설명을 하나 이상 추가해 주세요.',
      'alertConfirm': '확인',
    },
    'th': {
      'defaultTitle': 'รายงานไม่มีชื่อ',
      'dialogTitle': 'บันทึกอาหารใหม่',
      'dialogDescription':
          'อัปโหลดรูปอาหารและเพิ่มคำอธิบาย AI จะวิเคราะห์ความปลอดภัยด้านอาหารให้คุณ',
      'foodPhotos': 'รูปอาหาร',
      'add': 'เพิ่ม',
      'titleLabel': 'หัวข้อ',
      'titleHint': 'เช่น: ข้าวกล่องมื้อเที่ยง',
      'descriptionLabel': 'คำอธิบาย (ไม่บังคับ)',
      'descriptionHint':
          'เพิ่มรายละเอียดเกี่ยวกับอาหาร วัตถุดิบ หรือคำถามที่ต้องการทราบ…',
      'cancel': 'ยกเลิก',
      'startAnalysis': 'เริ่มวิเคราะห์',
      'alertTitle': 'ข้อมูลไม่ครบ',
      'alertMessage': 'กรุณาเพิ่มรูปหรือคำอธิบายอย่างน้อยหนึ่งรายการก่อนส่ง',
      'alertConfirm': 'ตกลง',
    },
    'vi': {
      'defaultTitle': 'Báo cáo chưa đặt tên',
      'dialogTitle': 'Ghi chép bữa ăn mới',
      'dialogDescription':
          'Tải ảnh thực phẩm và thêm mô tả. AI sẽ phân tích an toàn thực phẩm cho bạn.',
      'foodPhotos': 'Ảnh thực phẩm',
      'add': 'Thêm',
      'titleLabel': 'Tiêu đề',
      'titleHint': 'Ví dụ: Hộp cơm trưa',
      'descriptionLabel': 'Mô tả (tùy chọn)',
      'descriptionHint':
          'Bổ sung thông tin về thực phẩm, nguyên liệu hoặc câu hỏi bạn muốn biết…',
      'cancel': 'Hủy',
      'startAnalysis': 'Bắt đầu phân tích',
      'alertTitle': 'Thiếu thông tin',
      'alertMessage': 'Vui lòng thêm ít nhất một ảnh hoặc mô tả trước khi gửi.',
      'alertConfirm': 'OK',
    },
  };

  /// 關於對話框
  static final Map<String, Map<String, String>> aboutDialogTexts = {
    'en': {
      'subtitle': 'Pregnancy Diet Safety Assistant',
      'description':
          'IngreSafe is an AI-powered diet management app designed for pregnant women. Through intelligent analysis and personalized reference information, it helps users better understand their dietary situation and improve health awareness.',
      'descriptionAndroid':
          'IngreSafe helps analyze product ingredients to ensure safety for pregnant or breastfeeding women. We do not collect any of your information. All information is store in your local device. If you want support us we have a Buymeacoffee. Any support will be greatly appreciate and will push us to create more useful product.',
      'feature1Title': 'Food Safety Analysis',
      'feature1Desc':
          'Take or upload food photos for AI to instantly assess pregnancy dietary risk levels',
      'feature2Title': 'Reference-Backed Evidence',
      'feature2Desc':
          'Each report includes reliable medical literature and nutritional references',
      'feature3Title': 'Risk Level Indicators',
      'feature3Desc':
          'Low, medium, and high risk levels for clear dietary safety at a glance',
      'disclaimerAbout':
          '⚠️ Disclaimer: Information provided by this app is for reference only and does not constitute medical advice. If you have any health concerns, please consult a medical professional.',
      'version': 'Version',
    },
    'zh_Hant': {
      'subtitle': '孕期飲食安全智慧助手',
      'description':
          'IngreSafe 是一款以教育與知識輔助為核心的 AI 飲食管理 App，專為孕婦設計，透過智慧分析與個人化參考資訊，協助使用者更了解自身飲食狀況，提升健康意識。',
      'descriptionAndroid':
          'IngreSafe 協助分析產品成分，確保對孕婦或哺乳期女性的安全。我們不會收集您的任何資訊，所有資料都儲存在您的本地設備上。如果您願意支持我們，我們有 Buy Me a Coffee 頁面。您的支持將讓我們非常感激，並激勵我們開發更多實用的產品。',
      'feature1Title': '食物安全分析',
      'feature1Desc': '拍攝或上傳食物照片，AI 即時評估孕期食用風險等級',
      'feature2Title': '參考文獻佐證',
      'feature2Desc': '每份報告皆附上可靠的醫學文獻與營養學參考資料',
      'feature3Title': '風險等級標示',
      'feature3Desc': '以低、中、高風險三級標示，一目了然掌握飲食安全',
      'disclaimerAbout': '⚠️ 免責聲明：本應用程式提供之資訊僅供參考，不構成醫療建議。如有任何健康疑慮，請諮詢專業醫療人員。',
      'version': '版本',
    },
    'ja': {
      'subtitle': '妊娠中の食事安全アシスタント',
      'description':
          'IngreSafe は、妊婦向けに設計された AI 食事管理アプリです。インテリジェントな分析とパーソナライズされた参考情報により、ユーザーが自身の食生活をより深く理解し、健康意識を高めるお手伝いをします。',
      'descriptionAndroid':
          'IngreSafeは、妊婦や授乳中の女性にとって安全な製品成分の分析をサポートします。私たちはあなたの情報を収集することはありません。すべてのデータはあなたのローカルデバイスに保存されます。もし私たちをサポートしたい場合は、Buy Me a Coffeeページがあります。どんなサポートも大変感謝しており、それが私たちにとって新しい有用な製品を作り続ける力となります。',
      'feature1Title': '食品安全分析',
      'feature1Desc': '食べ物の写真を撮影またはアップロードし、AIが妊娠中の食事リスクを即座に評価',
      'feature2Title': '参考文献による裏付け',
      'feature2Desc': '各レポートには信頼性の高い医学文献と栄養学の参考資料が添付',
      'feature3Title': 'リスクレベル表示',
      'feature3Desc': '低・中・高の3段階リスク表示で、食事の安全性を一目で把握',
      'disclaimerAbout':
          '⚠️ 免責事項：本アプリが提供する情報は参考用であり、医療上のアドバイスを構成するものではありません。健康に関する懸念がある場合は、専門の医療従事者にご相談ください。',
      'version': 'バージョン',
    },
    'ko': {
      'subtitle': '임신 식이 안전 스마트 어시스턴트',
      'description':
          'IngreSafe는 임산부를 위해 설계된 AI 식이 관리 앱입니다. 지능적인 분석과 개인화된 참고 정보를 통해 사용자가 자신의 식이 상태를 더 잘 이해하고 건강 의식을 높이도록 돕습니다.',
      'descriptionAndroid':
          'IngreSafe는 임산부와 수유부를 위한 제품 성분의 안전성을 분석하는 데 도움을 줍니다. 저희는 어떠한 정보도 수집하지 않으며, 모든 데이터는 사용자의 로컬 기기에 저장됩니다. 저희를 응원하고 싶다면 Buy Me a Coffee 페이지를 통해 지원해주실 수 있습니다. 여러분의 소중한 지원은 저희에게 큰 힘이 되며, 더 유용한 제품을 만드는 데 도움이 됩니다.',
      'feature1Title': '식품 안전 분석',
      'feature1Desc': '음식 사진을 촬영하거나 업로드하면 AI가 임신 중 식이 위험 수준을 즉시 평가',
      'feature2Title': '참고 문헌 근거',
      'feature2Desc': '각 보고서에는 신뢰할 수 있는 의학 문헌과 영양학 참고 자료가 첨부',
      'feature3Title': '위험 수준 표시',
      'feature3Desc': '저, 중, 고 3단계 위험 표시로 식이 안전을 한눈에 파악',
      'disclaimerAbout':
          '⚠️ 면책 조항: 이 앱이 제공하는 정보는 참고용이며 의료 조언을 구성하지 않습니다. 건강에 대한 우려가 있으시면 전문 의료인과 상담하세요.',
      'version': '버전',
    },
    'th': {
      'subtitle': 'ผู้ช่วยอัจฉริยะด้านความปลอดภัยอาหารสำหรับคนท้อง',
      'description':
          'IngreSafe เป็นแอปจัดการอาหารที่ขับเคลื่อนด้วย AI ออกแบบมาเพื่อคุณแม่ตั้งครรภ์ ช่วยวิเคราะห์อย่างชาญฉลาดพร้อมข้อมูลอ้างอิงส่วนบุคคล เพื่อให้ผู้ใช้เข้าใจสถานะโภชนาการและเพิ่มความตระหนักด้านสุขภาพ',
      'descriptionAndroid':
          'IngreSafe ช่วยวิเคราะห์ส่วนผสมของผลิตภัณฑ์เพื่อให้แน่ใจว่าปลอดภัยสำหรับหญิงตั้งครรภ์หรือให้นมบุตร เราไม่เก็บข้อมูลใด ๆ ของคุณ ข้อมูลทั้งหมดจะถูกเก็บไว้ในอุปกรณ์ของคุณ หากคุณต้องการสนับสนุนเรา เรามีหน้า Buy Me a Coffee ทุกการสนับสนุนมีความหมายและช่วยให้เราพัฒนาผลิตภัณฑ์ที่มีประโยชน์มากขึ้น',
      'feature1Title': 'การวิเคราะห์ความปลอดภัยของอาหาร',
      'feature1Desc':
          'ถ่ายหรืออัปโหลดรูปอาหาร AI ประเมินระดับความเสี่ยงด้านอาหารสำหรับคนท้องทันที',
      'feature2Title': 'หลักฐานอ้างอิง',
      'feature2Desc':
          'ทุกรายงานมาพร้อมเอกสารทางการแพทย์และข้อมูลโภชนาการที่เชื่อถือได้',
      'feature3Title': 'ตัวบ่งชี้ระดับความเสี่ยง',
      'feature3Desc':
          'แสดงระดับความเสี่ยง 3 ระดับ ต่ำ กลาง สูง เพื่อเข้าใจความปลอดภัยด้านอาหารได้ทันที',
      'disclaimerAbout':
          '⚠️ ข้อจำกัดความรับผิดชอบ: ข้อมูลที่แอปนี้ให้เป็นข้อมูลอ้างอิงเท่านั้น ไม่ถือเป็นคำแนะนำทางการแพทย์ หากมีข้อกังวลด้านสุขภาพ กรุณาปรึกษาแพทย์ผู้เชี่ยวชาญ',
      'version': 'เวอร์ชัน',
    },
    'vi': {
      'subtitle': 'Trợ lý thông minh an toàn thực phẩm thai kỳ',
      'description':
          'IngreSafe là ứng dụng quản lý chế độ ăn bằng AI được thiết kế cho phụ nữ mang thai. Thông qua phân tích thông minh và thông tin tham khảo cá nhân hóa, giúp người dùng hiểu rõ hơn tình trạng dinh dưỡng và nâng cao ý thức sức khỏe.',
      'descriptionAndroid':
          'IngreSafe giúp phân tích thành phần sản phẩm để đảm bảo an toàn cho phụ nữ mang thai hoặc đang cho con bú. Chúng tôi không thu thập bất kỳ thông tin nào của bạn. Tất cả dữ liệu được lưu trên thiết bị của bạn. Nếu bạn muốn ủng hộ chúng tôi, hãy ghé trang Buy Me a Coffee. Sự ủng hộ của bạn sẽ giúp chúng tôi tạo ra nhiều sản phẩm hữu ích hơn.',
      'feature1Title': 'Phân tích an toàn thực phẩm',
      'feature1Desc':
          'Chụp hoặc tải ảnh thực phẩm, AI đánh giá ngay mức độ rủi ro thực phẩm thai kỳ',
      'feature2Title': 'Bằng chứng tham khảo',
      'feature2Desc':
          'Mỗi báo cáo đều có tài liệu y khoa và dinh dưỡng đáng tin cậy',
      'feature3Title': 'Chỉ báo mức độ rủi ro',
      'feature3Desc':
          'Hiển thị 3 cấp độ rủi ro thấp, trung bình, cao để nắm bắt an toàn thực phẩm ngay lập tức',
      'disclaimerAbout':
          '⚠️ Tuyên bố miễn trừ trách nhiệm: Thông tin do ứng dụng này cung cấp chỉ mang tính tham khảo, không cấu thành lời khuyên y tế. Nếu có bất kỳ lo ngại nào về sức khỏe, vui lòng tham khảo ý kiến chuyên gia y tế.',
      'version': 'Phiên bản',
    },
  };

  /// 底部導航欄
  static final Map<String, Map<String, String>> bottomNavTexts = {
    'en': {'camera': 'Camera', 'gallery': 'Gallery', 'about': 'About'},
    'zh_Hant': {'camera': '拍照', 'gallery': '相簿', 'about': '關於'},
    'ja': {'camera': '撮影', 'gallery': 'アルバム', 'about': '情報'},
    'ko': {'camera': '촬영', 'gallery': '앨범', 'about': '정보'},
    'th': {'camera': 'ถ่ายรูป', 'gallery': 'อัลบั้ม', 'about': 'เกี่ยวกับ'},
    'vi': {'camera': 'Chụp ảnh', 'gallery': 'Thư viện', 'about': 'Giới thiệu'},
  };

  /// 報告卡片
  static final Map<String, Map<String, String>> reportCardTexts = {
    'en': {'confirmDelete': 'Tap again to confirm delete'},
    'zh_Hant': {'confirmDelete': '再按一次確認刪除'},
    'ja': {'confirmDelete': 'もう一度タップして削除を確認'},
    'ko': {'confirmDelete': '다시 탭하여 삭제 확인'},
    'th': {'confirmDelete': 'แตะอีกครั้งเพื่อยืนยันการลบ'},
    'vi': {'confirmDelete': 'Nhấn lần nữa để xác nhận xóa'},
  };

  /// 教學引導
  static final Map<String, Map<String, String>> tutorialTexts = {
    'en': {
      'cameraTitle': 'Take a Photo',
      'cameraDesc':
          'Tap to photograph food. AI will assess pregnancy safety instantly.',
      'galleryTitle': 'Upload from Library',
      'galleryDesc': 'Select multiple photos for batch analysis.',
      'uploadHint':
          'Enter a title and optional notes, then tap "Start Analysis" for AI safety assessment.',
      'cardTitle': 'Analysis Report',
      'cardDesc':
          'View the AI risk level. Tap the card to see the full detailed report.',
      'sampleTitle': 'Example: Salmon Sashimi',
      'sampleSummary':
          'Salmon is a low-risk food. Safe for pregnant women in moderation (2–3 servings per week).',
      'sampleAnalysis':
          '## Salmon Sashimi\n\nSalmon is generally **low risk** for pregnant women.\n\n### Key Points\n- Rich in Omega-3 fatty acids, beneficial for fetal brain development\n- Moderate consumption recommended (2–3 servings per week)\n- Choose fresh, reputable sources to avoid parasites\n\n[RISK_LEVEL:low]',
    },
    'zh_Hant': {
      'cameraTitle': '拍照分析',
      'cameraDesc': '點擊拍攝食物照片，AI 立即評估孕期食用安全性。',
      'galleryTitle': '從相簿選取',
      'galleryDesc': '可一次選取多張照片批量分析。',
      'uploadHint': '輸入標題與備註後，點擊「開始分析」，AI 將為你評估食材安全性。',
      'cardTitle': '分析報告卡',
      'cardDesc': '查看 AI 風險評估等級，點擊卡片可查看完整詳細報告。',
      'sampleTitle': '範例：鮭魚生魚片',
      'sampleSummary': '鮭魚屬於低風險食材，適量食用對孕婦安全（每週 2–3 次）。',
      'sampleAnalysis':
          '## 鮭魚生魚片\n\n鮭魚對孕婦而言屬於**低風險**食材。\n\n### 重點摘要\n- 富含 Omega-3 脂肪酸，有助胎兒腦部發育\n- 建議適量食用（每週 2–3 次）\n- 選擇新鮮、有信譽的來源以避免寄生蟲\n\n[RISK_LEVEL:low]',
    },
    'ja': {
      'cameraTitle': '写真を撮る',
      'cameraDesc': '食べ物を撮影してAIが妊娠中の安全性を即時評価します。',
      'galleryTitle': 'ライブラリから選択',
      'galleryDesc': '複数の写真を選んで一括分析できます。',
      'uploadHint': 'タイトルとメモを入力し、「分析開始」をタップするとAIが安全性を評価します。',
      'cardTitle': '分析レポートカード',
      'cardDesc': 'AIのリスク評価を確認。カードをタップすると詳細レポートが見られます。',
      'sampleTitle': '例：サーモン刺身',
      'sampleSummary': 'サーモンは低リスク食材。適量（週2〜3回）なら妊婦に安全です。',
      'sampleAnalysis':
          '## サーモン刺身\n\nサーモンは妊婦にとって**低リスク**食材です。\n\n### ポイント\n- Omega-3脂肪酸が豊富で胎児の脳発育に有益\n- 適量摂取を推奨（週2〜3回）\n- 寄生虫を避けるため新鮮な信頼できる食材を選ぶ\n\n[RISK_LEVEL:low]',
    },
    'ko': {
      'cameraTitle': '사진 촬영',
      'cameraDesc': '음식 사진을 찍으면 AI가 임신 중 안전성을 즉시 평가합니다.',
      'galleryTitle': '라이브러리에서 선택',
      'galleryDesc': '여러 장의 사진을 선택해 일괄 분석할 수 있습니다.',
      'uploadHint': '제목과 메모를 입력한 후 "분석 시작"을 탭하면 AI가 안전성을 평가합니다.',
      'cardTitle': '분석 보고서 카드',
      'cardDesc': 'AI 위험도 평가를 확인하세요. 카드를 탭하면 상세 보고서를 볼 수 있습니다.',
      'sampleTitle': '예시: 연어 회',
      'sampleSummary': '연어는 저위험 식품으로 임산부가 적당히 섭취해도 안전합니다(주 2~3회).',
      'sampleAnalysis':
          '## 연어 회\n\n연어는 임산부에게 **저위험** 식품입니다.\n\n### 주요 사항\n- Omega-3 지방산이 풍부하여 태아 뇌 발달에 도움\n- 적당한 섭취 권장(주 2~3회)\n- 기생충을 피하기 위해 신선하고 신뢰할 수 있는 식품 선택\n\n[RISK_LEVEL:low]',
    },
    'th': {
      'cameraTitle': 'ถ่ายรูปอาหาร',
      'cameraDesc': 'ถ่ายรูปอาหารเพื่อให้ AI ประเมินความปลอดภัยสำหรับคนท้อง',
      'galleryTitle': 'เลือกจากคลังรูป',
      'galleryDesc': 'เลือกหลายรูปพร้อมกันเพื่อวิเคราะห์',
      'uploadHint':
          'ใส่ชื่อและหมายเหตุ แล้วกด "เริ่มวิเคราะห์" เพื่อให้ AI ตรวจสอบ',
      'cardTitle': 'การ์ดรายงาน',
      'cardDesc': 'ดูระดับความเสี่ยงจาก AI กดที่การ์ดเพื่อดูรายงานเต็ม',
      'sampleTitle': 'ตัวอย่าง: แซลมอน',
      'sampleSummary': 'แซลมอนเป็นอาหารความเสี่ยงต่ำ ทานได้ในปริมาณที่เหมาะสม',
      'sampleAnalysis':
          '## แซลมอน\n\nแซลมอนมี**ความเสี่ยงต่ำ**สำหรับคนท้อง\n\n### สรุป\n- อุดมด้วย Omega-3 ช่วยพัฒนาสมองของทารก\n- แนะนำให้ทานในปริมาณที่เหมาะสม (2–3 ครั้ง/สัปดาห์)\n\n[RISK_LEVEL:low]',
    },
    'vi': {
      'cameraTitle': 'Chụp ảnh',
      'cameraDesc':
          'Chụp ảnh thực phẩm để AI đánh giá độ an toàn khi mang thai.',
      'galleryTitle': 'Chọn từ thư viện',
      'galleryDesc': 'Chọn nhiều ảnh để phân tích cùng lúc.',
      'uploadHint':
          'Nhập tiêu đề và ghi chú, sau đó nhấn "Bắt đầu phân tích" để AI đánh giá an toàn.',
      'cardTitle': 'Thẻ báo cáo',
      'cardDesc':
          'Xem đánh giá rủi ro của AI. Nhấn vào thẻ để xem báo cáo chi tiết.',
      'sampleTitle': 'Ví dụ: Cá hồi',
      'sampleSummary':
          'Cá hồi là thực phẩm rủi ro thấp, an toàn khi dùng vừa phải (2–3 lần/tuần).',
      'sampleAnalysis':
          '## Cá hồi\n\nCá hồi có **rủi ro thấp** với phụ nữ mang thai.\n\n### Điểm chính\n- Giàu Omega-3, hỗ trợ phát triển não bộ của thai nhi\n- Nên dùng vừa phải (2–3 lần/tuần)\n\n[RISK_LEVEL:low]',
    },
  };

  /// 風險等級標籤（用於 RiskLevelConfig）
  static final Map<String, Map<String, String>> riskLevelLabels = {
    'en': {
      'low': 'Safe',
      'medium': 'Caution',
      'high': 'Avoid',
      'unknown': 'Uncertain'
    },
    'zh_Hant': {'low': '安全', 'medium': '注意', 'high': '避免', 'unknown': '不確定'},
    'ja': {'low': '安全', 'medium': '注意', 'high': '控える', 'unknown': '不明'},
    'ko': {'low': '안전', 'medium': '주의', 'high': '삼가세요', 'unknown': '불확실'},
    'th': {
      'low': 'ปลอดภัย',
      'medium': 'ระวัง',
      'high': 'หลีกเลี่ยง',
      'unknown': 'ไม่แน่ใจ'
    },
    'vi': {
      'low': 'An toàn',
      'medium': 'Thận trọng',
      'high': 'Tránh',
      'unknown': 'Không rõ'
    },
  };

  /// 安全警告對話框
  static final Map<String, Map<String, String>> safetyWarningTexts = {
    'en': {
      'title': 'Safety Notice',
      'subtitle': 'Please read the following before using',
      'warning1Title': 'Toxic Substances',
      'warning1Desc':
          'AI analyzes food safety based on photos only. It cannot identify toxic substances, drugs, or harmful additives hidden in food. Please ensure your food is free from any hazardous materials before analysis.',
      'warning2Title': 'Show All Food Clearly',
      'warning2Desc':
          'Please photograph all food items in full view — avoid stacking or hiding items underneath. If some food cannot be shown, describe it in the text field so AI can analyze it properly.',
      'confirm': 'Got It',
      'dontShowAgain': "Don't Show Again",
      'viewSafetyNotice': 'View Safety Notice',
    },
    'zh_Hant': {
      'title': '安全提醒',
      'subtitle': '使用前請詳閱以下注意事項',
      'warning1Title': '有毒物質',
      'warning1Desc':
          'AI 僅能透過照片分析食物安全性，無法識別食物中是否含有毒品、有毒物質或有害添加物。請在分析前確認食物中不含任何有害物質。',
      'warning2Title': '請完整展示所有食物',
      'warning2Desc':
          '拍攝時請將所有食物完整呈現，避免食物被覆蓋或堆疊。若有無法拍攝到的食物，請在文字說明中補充，以便 AI 進行完整分析。',
      'confirm': '我知道了',
      'dontShowAgain': '不再顯示',
      'viewSafetyNotice': '查看安全提醒',
    },
    'ja': {
      'title': '安全に関するご注意',
      'subtitle': 'ご利用前に以下をお読みください',
      'warning1Title': '有毒物質',
      'warning1Desc':
          'AIは写真のみで食品の安全性を分析します。食品に含まれる有毒物質、薬物、有害な添加物を識別することはできません。分析前に食品に有害物質が含まれていないことをご確認ください。',
      'warning2Title': 'すべての食品を明確に撮影してください',
      'warning2Desc':
          '撮影時はすべての食品を完全に見えるようにし、重ねたり隠したりしないでください。撮影できない食品がある場合は、テキスト欄に記載してAIが正確に分析できるようにしてください。',
      'confirm': '了解しました',
      'dontShowAgain': '今後表示しない',
      'viewSafetyNotice': '安全に関するご注意を表示',
    },
    'ko': {
      'title': '안전 안내',
      'subtitle': '사용 전 다음 사항을 확인해 주세요',
      'warning1Title': '유독 물질',
      'warning1Desc':
          'AI는 사진만으로 식품 안전성을 분석합니다. 음식에 숨겨진 유독 물질, 마약, 유해 첨가물은 식별할 수 없습니다. 분석 전에 음식에 유해 물질이 없는지 확인해 주세요.',
      'warning2Title': '모든 음식을 선명하게 촬영해 주세요',
      'warning2Desc':
          '촬영 시 모든 음식을 완전히 보이도록 하고, 겹치거나 숨기지 마세요. 촬영할 수 없는 음식이 있으면 텍스트 설명에 추가하여 AI가 정확하게 분석할 수 있도록 해주세요.',
      'confirm': '확인했습니다',
      'dontShowAgain': '다시 표시 안 함',
      'viewSafetyNotice': '안전 안내 보기',
    },
    'th': {
      'title': 'ข้อควรระวังด้านความปลอดภัย',
      'subtitle': 'กรุณาอ่านข้อมูลต่อไปนี้ก่อนใช้งาน',
      'warning1Title': 'สารพิษ',
      'warning1Desc':
          'AI วิเคราะห์ความปลอดภัยของอาหารจากรูปถ่ายเท่านั้น ไม่สามารถระบุสารพิษ สารเสพติด หรือสารเติมแต่งที่เป็นอันตรายซ่อนอยู่ในอาหารได้ กรุณาตรวจสอบให้แน่ใจว่าอาหารปราศจากสารอันตรายก่อนทำการวิเคราะห์',
      'warning2Title': 'แสดงอาหารทั้งหมดให้ชัดเจน',
      'warning2Desc':
          'กรุณาถ่ายรูปอาหารทุกรายการให้เห็นชัดเจน หลีกเลี่ยงการวางซ้อนหรือซ่อนอาหาร หากมีอาหารที่ไม่สามารถถ่ายรูปได้ กรุณาอธิบายในช่องข้อความเพื่อให้ AI วิเคราะห์ได้อย่างถูกต้อง',
      'confirm': 'รับทราบ',
      'dontShowAgain': 'ไม่ต้องแสดงอีก',
      'viewSafetyNotice': 'ดูข้อควรระวังด้านความปลอดภัย',
    },
    'vi': {
      'title': 'Lưu ý an toàn',
      'subtitle': 'Vui lòng đọc trước khi sử dụng',
      'warning1Title': 'Chất độc',
      'warning1Desc':
          'AI chỉ phân tích an toàn thực phẩm dựa trên ảnh chụp. AI không thể nhận diện chất độc, ma túy hoặc chất phụ gia có hại ẩn trong thức ăn. Vui lòng đảm bảo thực phẩm không chứa chất có hại trước khi phân tích.',
      'warning2Title': 'Hiển thị rõ tất cả thực phẩm',
      'warning2Desc':
          'Khi chụp ảnh, vui lòng hiển thị đầy đủ tất cả thức ăn — tránh xếp chồng hoặc che giấu. Nếu có thực phẩm không thể chụp được, hãy mô tả trong ô văn bản để AI có thể phân tích chính xác.',
      'confirm': 'Đã hiểu',
      'dontShowAgain': 'Không hiển thị lại',
      'viewSafetyNotice': 'Xem lưu ý an toàn',
    },
  };
}
