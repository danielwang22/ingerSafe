import 'dart:io';

/// 應用程式多語言文字常數
class AppStrings {
  /// 語言名稱的多語言對照表
  static final Map<String, Map<String, String>> languageNames = {
    'en': {
      'English': 'English',
      'Traditional_Chinese': '繁體中文',
      'Japanese': '日本語',
      'Korean': '한국어',
      'Thai': 'Thai',
      'Vietnamese': 'Vietnamese',
    },
    'zh_Hant': {
      'English': 'English',
      'Traditional_Chinese': '繁體中文',
      'Japanese': '日本語',
      'Korean': '한국어',
      'Thai': '泰文',
      'Vietnamese': '越南文',
    },
    'ja': {
      'English': 'English',
      'Traditional_Chinese': '繁體中文',
      'Japanese': '日本語',
      'Korean': '한국어',
      'Thai': 'タイ語',
      'Vietnamese': 'ベトナム語',
    },
    'ko': {
      'English': 'English',
      'Traditional_Chinese': '繁體中文',
      'Japanese': '日本語',
      'Korean': '한국어',
      'Thai': '태국어',
      'Vietnamese': '베트남어',
    },
    'th': {
      'English': 'English',
      'Traditional_Chinese': '繁體中文',
      'Japanese': '日本語',
      'Korean': '한국어',
      'Thai': 'ไทย',
      'Vietnamese': 'Tiếng Việt',
    },
    'vi': {
      'English': 'English',
      'Traditional_Chinese': '繁體中文',
      'Japanese': '日本語',
      'Korean': '한국어',
      'Thai': 'Tiếng Thái',
      'Vietnamese': 'Tiếng Việt',
    },
  };

  /// 首頁畫面使用的文字常數
  static final Map<String, Map<String, String>> homeScreenTexts = {
    'English': {
      'currentLanguage': 'Current Language',
      'noHistory': 'No history yet. Take a photo to get started!',
      'cameraError':
          'Camera not supported or unavailable. Try selecting from gallery.',
      'galleryError': 'Unable to access gallery. Please try again later.',
      'webUnsupported':
          'Text recognition is not supported on the web. Please use the mobile app.',
      'takePhoto': 'Take Photo',
      'chooseFromGallery': 'Choose from Gallery',
      'useTestImage': 'Use Test Image',
      'aiResult': "Ai Result",
      'aboutUsHeading': 'About Us',
      'aboutUsMessage': Platform.isAndroid
          ? 'IngreSafe helps analyze product ingredients to ensure safety for babies. We do not collect any of your information. All information is store in your local device. If you want support us we have a Buymeacoffee. Any support will be greatly appreciate and will push us to create more useful product.'
          : 'IngreSafe helps analyze product ingredients to ensure safety for babies. We do not collect any of your information. All information is store in your local device.',
      'cameraTip': 'Take a photo and analyze the ingredient list.',
      'galleryTip':
          'Choose an image from the gallery and then analyze the ingredient list.',
      'aboutUsTip': 'About Us',
      'delete': 'Delete',
      'reference': 'Reference',
      'dailyDiet': 'Daily Diet'
    },
    'Traditional_Chinese': {
      'currentLanguage': '目前語言',
      'noHistory': '尚無歷史紀錄，請拍照開始使用！',
      'cameraError': '相機不支援或無法使用，請嘗試從相簿選擇照片',
      'galleryError': '無法存取相簿，請稍後再試',
      'webUnsupported': 'Web 平台暫不支援圖片文字識別，請使用手機 App',
      'takePhoto': '拍照',
      'chooseFromGallery': '從相簿選擇',
      'useTestImage': '使用測試圖片',
      'aiResult': "AI 結果",
      'aboutUsHeading': '關於我們',
      'aboutUsMessage': Platform.isAndroid
          ? 'IngreSafe 協助分析產品成分，確保對嬰兒的安全。我們不會收集您的任何資訊，所有資料都儲存在您的本地設備上。如果您願意支持我們，我們有 Buy Me a Coffee 頁面。您的支持將讓我們非常感激，並激勵我們開發更多實用的產品。'
          : 'IngreSafe 協助分析產品成分，確保對嬰兒的安全。我們不會收集您的任何資訊，所有資料都儲存在您的本地設備上。',
      'cameraTip': '請拍一張照片，並分析成分列表。',
      'galleryTip': '請從圖庫選擇一張圖片，然後分析成分列表。',
      'aboutUsTip': '關於我們',
      'delete': '刪除',
      'reference': '參考資料',
      'dailyDiet': '該月該日的飲食'
    },
    'Japanese': {
      'currentLanguage': '現在の言語',
      'noHistory': '履歴がありません。写真を撮って始めましょう！',
      'cameraError': 'カメラが使用できません。ギャラリーから選んでください。',
      'galleryError': 'ギャラリーにアクセスできません。後でもう一度お試しください。',
      'webUnsupported': 'Webでは文字認識がサポートされていません。モバイルアプリを使用してください。',
      'takePhoto': '写真を撮る',
      'chooseFromGallery': 'ギャラリーから選ぶ',
      'useTestImage': 'テスト画像を使う',
      'aiResult': "AI結果",
      'aboutUsHeading': '私たちについて',
      'aboutUsMessage': Platform.isAndroid
          ? 'IngreSafeは、赤ちゃんにとって安全な製品成分の分析をサポートします。私たちはあなたの情報を収集することはありません。すべてのデータはあなたのローカルデバイスに保存されます。もし私たちをサポートしたい場合は、Buy Me a Coffeeページがあります。どんなサポートも大変感謝しており、それが私たちにとって新しい有用な製品を作り続ける力となります。'
          : 'IngreSafeは、赤ちゃんにとって安全な製品成分の分析をサポートします。私たちはあなたの情報を収集することはありません。すべてのデータはあなたのローカルデバイスに保存されます。',
      'cameraTip': '写真を撮って、成分リストを分析してください。',
      'galleryTip': 'ギャラリーから画像を選んで、成分リストを分析してください。',
      'aboutUsTip': '私たちについて',
      'delete': '削除',
      'reference': '参考資料',
      'dailyDiet': 'その月その日の食事'
    },
    'Korean': {
      'currentLanguage': '현재 언어',
      'noHistory': '기록이 없습니다. 사진을 찍어 시작해보세요!',
      'cameraError': '카메라를 사용할 수 없습니다. 갤러리에서 선택해 주세요.',
      'galleryError': '갤러리에 접근할 수 없습니다. 나중에 다시 시도해 주세요.',
      'webUnsupported': '웹에서는 텍스트 인식이 지원되지 않습니다. 모바일 앱을 이용해 주세요.',
      'takePhoto': '사진 찍기',
      'chooseFromGallery': '갤러리에서 선택',
      'useTestImage': '테스트 이미지 사용',
      'aiResult': "AI 결과",
      'aboutUsHeading': '우리에 대해',
      'aboutUsMessage': Platform.isAndroid
          ? 'IngreSafe는 아기를 위한 제품 성분의 안전성을 분석하는 데 도움을 줍니다. 저희는 어떠한 정보도 수집하지 않으며, 모든 데이터는 사용자의 로컬 기기에 저장됩니다. 저희를 응원하고 싶다면 Buy Me a Coffee 페이지를 통해 지원해주실 수 있습니다. 여러분의 소중한 지원은 저희에게 큰 힘이 되며, 더 유용한 제품을 만드는 데 도움이 됩니다.'
          : 'IngreSafe는 아기를 위한 제품 성분의 안전성을 분석하는 데 도움을 줍니다. 저희는 어떠한 정보도 수집하지 않으며, 모든 데이터는 사용자의 로컬 기기에 저장됩니다.',
      'cameraTip': '사진을 찍고 성분 목록을 분석해 주세요.',
      'galleryTip': '갤러리에서 이미지를 선택한 후 성분 목록을 분석해 주세요.',
      'aboutUsTip': '우리에 대해',
      'delete': '삭제',
      'reference': '참고 자료',
      'dailyDiet': '그 달 그 날의 식사'
    },
    'Thai': {
      'currentLanguage': 'ภาษาปัจจุบัน',
      'noHistory': 'ยังไม่มีประวัติ ลองถ่ายรูปเพื่อเริ่มต้น!',
      'cameraError': 'ไม่รองรับกล้องหรือไม่สามารถใช้งานได้ ลองเลือกจากแกลเลอรี',
      'galleryError': 'ไม่สามารถเข้าถึงแกลเลอรีได้ โปรดลองอีกครั้งในภายหลัง',
      'webUnsupported': 'ยังไม่รองรับการรู้จำข้อความบนเว็บ โปรดใช้แอปบนมือถือ',
      'takePhoto': 'ถ่ายรูป',
      'chooseFromGallery': 'เลือกจากแกลเลอรี',
      'useTestImage': 'ใช้รูปทดสอบ',
      'aiResult': 'ผลลัพธ์ AI',
      'aboutUsHeading': 'เกี่ยวกับเรา',
      'aboutUsMessage': Platform.isAndroid
          ? 'IngreSafe ช่วยวิเคราะห์ส่วนผสมของผลิตภัณฑ์เพื่อให้แน่ใจว่าปลอดภัยสำหรับทารก เราไม่เก็บข้อมูลใด ๆ ของคุณ ข้อมูลทั้งหมดจะถูกเก็บไว้ในอุปกรณ์ของคุณ หากคุณต้องการสนับสนุนเรา เรามีหน้า Buy Me a Coffee ทุกการสนับสนุนมีความหมายและช่วยให้เราพัฒนาผลิตภัณฑ์ที่มีประโยชน์มากขึ้น'
          : 'IngreSafe ช่วยวิเคราะห์ส่วนผสมของผลิตภัณฑ์เพื่อให้แน่ใจว่าปลอดภัยสำหรับทารก เราไม่เก็บข้อมูลใด ๆ ของคุณ ข้อมูลทั้งหมดจะถูกเก็บไว้ในอุปกรณ์ของคุณ',
      'cameraTip': 'ถ่ายรูปแล้ววิเคราะห์รายการส่วนผสม',
      'galleryTip': 'เลือกรูปจากแกลเลอรี แล้ววิเคราะห์รายการส่วนผสม',
      'aboutUsTip': 'เกี่ยวกับเรา',
      'delete': 'ลบ',
      'reference': 'อ้างอิง',
      'dailyDiet': 'อาหารประจำวัน'
    },
    'Vietnamese': {
      'currentLanguage': 'Ngôn ngữ hiện tại',
      'noHistory': 'Chưa có lịch sử. Hãy chụp ảnh để bắt đầu!',
      'cameraError':
          'Không hỗ trợ camera hoặc không khả dụng. Hãy thử chọn từ thư viện.',
      'galleryError': 'Không thể truy cập thư viện. Vui lòng thử lại sau.',
      'webUnsupported':
          'Nền tảng web chưa hỗ trợ nhận dạng văn bản. Vui lòng dùng ứng dụng di động.',
      'takePhoto': 'Chụp ảnh',
      'chooseFromGallery': 'Chọn từ thư viện',
      'useTestImage': 'Dùng ảnh thử',
      'aiResult': 'Kết quả AI',
      'aboutUsHeading': 'Về chúng tôi',
      'aboutUsMessage': Platform.isAndroid
          ? 'IngreSafe giúp phân tích thành phần sản phẩm để đảm bảo an toàn cho em bé. Chúng tôi không thu thập bất kỳ thông tin nào của bạn. Tất cả dữ liệu được lưu trên thiết bị của bạn. Nếu bạn muốn ủng hộ chúng tôi, hãy ghé trang Buy Me a Coffee. Sự ủng hộ của bạn sẽ giúp chúng tôi tạo ra nhiều sản phẩm hữu ích hơn.'
          : 'IngreSafe giúp phân tích thành phần sản phẩm để đảm bảo an toàn cho em bé. Chúng tôi không thu thập bất kỳ thông tin nào của bạn. Tất cả dữ liệu được lưu trên thiết bị của bạn.',
      'cameraTip': 'Chụp ảnh và phân tích danh sách thành phần.',
      'galleryTip': 'Chọn ảnh từ thư viện rồi phân tích danh sách thành phần.',
      'aboutUsTip': 'Về chúng tôi',
      'delete': 'Xóa',
      'reference': 'Tham khảo',
      'dailyDiet': 'Chế độ ăn hằng ngày'
    },
  };

  /// AI 分析提示詞
  static final Map<String, String> prompts = {
    'en': """
      You are a professional health analysis assistant. Please analyze any recognizable ingredients or substances found in the image, and explain their potential negative effects on babies. If the image contains partial or unclear text, do your best to extract useful information.
      First, state whether the product appears dangerous overall.
      List any **dangerous or high-risk substances first**, followed by substances with **minor or low-level concerns**.
      Return results as a bullet list, using this format:
      - **Substance** – Short explanation of its potential effects.
      Respond in "English". Do not invent information that is not visible or recognizable in the image. Do not give dangerous or unverified advice.
    """,
    'zh_Hant': """
      你是一位專業的健康分析助手。請分析圖片中可識別的成分或物質，並說明它們對嬰兒可能產生的負面影響。如果圖片中的文字部分模糊或不完整，請盡可能提取有用的資訊。
      首先，請說明該產品整體上是否看起來具有危險性。
      請**先列出危險或高風險物質**，再列出**次要或低程度的疑慮物質**。
      請使用以下格式列出結果：
      - **物質名稱** – 簡短說明其可能的影響。
      請以「繁體中文」形式回應。請勿虛構圖片中沒有的資訊。請勿給出危險或未經驗證的建議。
    """,
    'ja': """
      あなたは専門的な健康分析アシスタントです。画像に含まれる識別可能な成分や物質を分析し、赤ちゃんに対する潜在的な悪影響について説明してください。画像内のテキストが一部不鮮明または不完全である場合は、可能な限り有用な情報を抽出してください。
      まず、製品全体が危険に見えるかどうかを述べてください。
      **危険またはリスクの高い物質を最初に**、**軽微または低リスクの懸念物質をその後に**リストしてください。
      次の形式で結果を返してください：
      - **物質名** – その可能性のある影響の簡単な説明。
      「日本語」の形式で回答してください。画像に表示されていない情報を作り出さないでください。危険または検証されていないアドバイスは提供しないでください。
    """,
    'ko': """
      당신은 전문적인 건강 분석 도우미입니다. 이미지에서 식별 가능한 성분이나 물질을 분석하고, 아기에게 미칠 수 있는 잠재적인 부정적인 영향을 설명해 주세요. 이미지에 있는 텍스트가 일부 불분명하거나 불완전한 경우, 최대한 유용한 정보를 추출해 주세요.
      먼저, 제품이 전반적으로 위험해 보이는지 여부를 명시해 주세요.
      **위험하거나 고위험 물질을 먼저**, **경미하거나 저위험 우려가 있는 물질은 그 다음에** 나열해 주세요.
      다음 형식으로 결과를 반환해 주세요:
      - **물질 이름** – 잠재적인 영향에 대한 간단한 설명.
      "한국어" 형식으로 응답해 주세요. 이미지에 표시되지 않은 정보를 임의로 생성하지 마세요. 위험하거나 검증되지 않은 조언은 제공하지 마세요.      
    """,
    'th': """
      คุณเป็นผู้ช่วยวิเคราะห์ด้านสุขภาพระดับมืออาชีพ โปรดวิเคราะห์ส่วนผสมหรือสารที่สามารถอ่านได้จากภาพ และอธิบายผลกระทบด้านลบที่อาจเกิดขึ้นกับทารก หากข้อความในภาพไม่ชัดเจนหรือไม่ครบถ้วน ให้พยายามดึงข้อมูลที่เป็นประโยชน์ให้มากที่สุด
      อันดับแรก โปรดระบุว่าผลิตภัณฑ์โดยรวมดูอันตรายหรือไม่
      โปรด **เรียงสารที่อันตรายหรือมีความเสี่ยงสูงก่อน** ตามด้วยสารที่มี **ความกังวลเล็กน้อยหรือความเสี่ยงต่ำ**
      ส่งผลลัพธ์เป็นรายการหัวข้อย่อยในรูปแบบ:
      - **สาร/ส่วนผสม** – คำอธิบายสั้น ๆ เกี่ยวกับผลกระทบที่เป็นไปได้
      โปรดตอบเป็นภาษา "ไทย" ห้ามแต่งข้อมูลที่ไม่เห็นหรืออ่านได้จากภาพ และห้ามให้คำแนะนำที่อันตรายหรือยังไม่ได้รับการยืนยัน
    """,
    'vi': """
      Bạn là trợ lý phân tích sức khỏe chuyên nghiệp. Hãy phân tích các thành phần/chất có thể nhận diện trong ảnh và giải thích các tác động tiêu cực tiềm ẩn đối với em bé. Nếu văn bản trong ảnh bị thiếu hoặc mờ, hãy cố gắng trích xuất thông tin hữu ích nhất có thể.
      Trước tiên, hãy cho biết sản phẩm nhìn chung có vẻ nguy hiểm hay không.
      Hãy liệt kê **các chất nguy hiểm hoặc rủi ro cao trước**, sau đó là các chất có **mức độ lo ngại nhỏ hoặc rủi ro thấp**.
      Trả về kết quả dạng danh sách gạch đầu dòng theo định dạng:
      - **Chất/Thành phần** – Giải thích ngắn về tác động tiềm ẩn.
      Vui lòng trả lời bằng "Tiếng Việt". Không bịa thông tin không nhìn thấy/không thể nhận diện từ ảnh. Không đưa ra lời khuyên nguy hiểm hoặc chưa được kiểm chứng.
    """,
  };

  static final Map<String, String> imagePrompts = {
    'en':
        'Please analyze whether this food product may have potential negative effects on babies.',
    'zh_Hant': '請分析此食物食品，是否對嬰兒可能產生的負面影響',
    'ja': 'この食品が赤ちゃんに悪影響を及ぼす可能性があるかどうかを分析してください。',
    'ko': '이 식품이 아기에게 부정적인 영향을 줄 가능성이 있는지 분석해 주세요.',
    'th': 'โปรดวิเคราะห์ว่าอาหาร/ผลิตภัณฑ์นี้อาจส่งผลเสียต่อทารกหรือไม่',
    'vi':
        'Vui lòng phân tích xem thực phẩm/sản phẩm này có thể gây ảnh hưởng tiêu cực đến em bé hay không.',
  };

  /// 結果對話框使用的文字常數
  static final Map<String, Map<String, String>> resultDialogTexts = {
    'en': {
      'analysisResult': 'Analysis Result',
      'noHarmfulIngredients': 'No harmful ingredients detected.',
      'potentiallyHarmfulIngredients': 'Potentially harmful ingredients:',
      'originalText': 'Original Text',
      'aiAnalysis': 'AI Analysis',
      'copyText': 'Copy Text',
      'copyOriginal': 'Original text copied',
      'copyAnalysis': 'Analysis copied',
      'disclaimer':
          'This app helps you look up information about ingredients. Always consult your doctor. This app does not provide medical advice.',
    },
    'zh_Hant': {
      'analysisResult': '分析結果',
      'noHarmfulIngredients': '未檢測到有害成分。',
      'potentiallyHarmfulIngredients': '可能有害的成分：',
      'originalText': '原始文字',
      'aiAnalysis': 'AI 分析',
      'copyText': '複製',
      'copyOriginal': '已複製原始文字',
      'copyAnalysis': '已複製分析結果',
      'disclaimer': '這款 App 協助您查詢成分相關資訊。請務必諮詢醫師，本 App 並不提供醫療建議。',
    },
    'ja': {
      'analysisResult': '分析結果',
      'noHarmfulIngredients': '有害な成分は検出されませんでした。',
      'potentiallyHarmfulIngredients': '潜在的に有害な成分：',
      'originalText': '原文',
      'aiAnalysis': 'AI分析',
      'copyText': 'コピー',
      'copyOriginal': '原文をコピーしました',
      'copyAnalysis': '分析結果をコピーしました',
      'disclaimer':
          'このアプリは成分に関する情報を調べるのに役立ちます。必ず医師にご相談ください。このアプリは医療アドバイスを提供するものではありません。',
    },
    'ko': {
      'analysisResult': '분석 결과',
      'noHarmfulIngredients': '해로운 성분이 감지되지 않았습니다.',
      'potentiallyHarmfulIngredients': '잠재적으로 해로운 성분:',
      'originalText': '원본 텍스트',
      'aiAnalysis': 'AI 분석',
      'copyText': '복사',
      'copyOriginal': '원본 텍스트가 복사되었습니다',
      'copyAnalysis': '분석 결과가 복사되었습니다',
      'disclaimer':
          '이 앱은 성분에 대한 정보를 확인하는 데 도움을 줍니다. 항상 의사와 상담하세요. 이 앱은 의학적 조언을 제공하지 않습니다.',
    },
    'th': {
      'analysisResult': 'ผลการวิเคราะห์',
      'noHarmfulIngredients': 'ไม่พบส่วนผสมที่เป็นอันตราย',
      'potentiallyHarmfulIngredients': 'ส่วนผสมที่อาจเป็นอันตราย:',
      'originalText': 'ข้อความต้นฉบับ',
      'aiAnalysis': 'การวิเคราะห์ AI',
      'copyText': 'คัดลอก',
      'copyOriginal': 'คัดลอกข้อความต้นฉบับแล้ว',
      'copyAnalysis': 'คัดลอกผลการวิเคราะห์แล้ว',
      'disclaimer':
          'แอปนี้ช่วยค้นหาข้อมูลเกี่ยวกับส่วนผสม โปรดปรึกษาแพทย์เสมอ แอปนี้ไม่ได้ให้คำแนะนำทางการแพทย์',
    },
    'vi': {
      'analysisResult': 'Kết quả phân tích',
      'noHarmfulIngredients': 'Không phát hiện thành phần có hại.',
      'potentiallyHarmfulIngredients': 'Các thành phần có thể gây hại:',
      'originalText': 'Văn bản gốc',
      'aiAnalysis': 'Phân tích AI',
      'copyText': 'Sao chép',
      'copyOriginal': 'Đã sao chép văn bản gốc',
      'copyAnalysis': 'Đã sao chép kết quả phân tích',
      'disclaimer':
          'Ứng dụng này giúp bạn tra cứu thông tin về thành phần. Hãy luôn tham khảo ý kiến bác sĩ. Ứng dụng này không cung cấp lời khuyên y tế.',
    },
  };
}
