import os
import sys
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
import arabic_reshaper
from bidi.algorithm import get_display

# Register Arabic font from Windows Fonts
font_path = r"C:\Windows\Fonts\arial.ttf"
if not os.path.exists(font_path):
    font_path = r"C:\Windows\Fonts\tahoma.ttf"

pdfmetrics.registerFont(TTFont("ArabicArial", font_path))

def ar(text):
    """Reshape and reorder Arabic text for correct RTL display in ReportLab."""
    if not text:
        return ""
    reshaped = arabic_reshaper.reshape(text)
    return get_display(reshaped)

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            canvas.Canvas.showPage(self)
        canvas.Canvas.save(self)

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 9)
        self.setFillColor(colors.HexColor("#64748B"))
        # Footer
        footer_text = f"Movie App - Clean Architecture API Guide | Page {self._pageNumber} of {page_count}"
        self.drawCentredString(A4[0] / 2.0, 25, footer_text)
        self.restoreState()

def build_pdf():
    pdf_filename = r"f:\ROUTE 2026\flutter project\movie_app\api_flow_guide.pdf"
    doc = SimpleDocTemplate(
        pdf_filename,
        pagesize=A4,
        leftMargin=36,
        rightMargin=36,
        topMargin=36,
        bottomMargin=45
    )

    styles = getSampleStyleSheet()

    # Custom Styles
    ar_title_style = ParagraphStyle(
        "ArTitle",
        fontName="ArabicArial",
        fontSize=20,
        leading=26,
        textColor=colors.HexColor("#F59E0B"),
        alignment=1, # Center
        spaceAfter=6
    )

    ar_subtitle_style = ParagraphStyle(
        "ArSubTitle",
        fontName="ArabicArial",
        fontSize=12,
        leading=16,
        textColor=colors.HexColor("#94A3B8"),
        alignment=1,
        spaceAfter=15
    )

    ar_heading_style = ParagraphStyle(
        "ArHeading",
        fontName="ArabicArial",
        fontSize=14,
        leading=18,
        textColor=colors.HexColor("#1E293B"),
        spaceBefore=12,
        spaceAfter=8,
        alignment=2 # Right
    )

    ar_body_style = ParagraphStyle(
        "ArBody",
        fontName="ArabicArial",
        fontSize=10.5,
        leading=15,
        textColor=colors.HexColor("#334155"),
        alignment=2, # Right
        spaceAfter=6
    )

    code_style = ParagraphStyle(
        "CodeStyle",
        fontName="Courier",
        fontSize=8.5,
        leading=11,
        textColor=colors.HexColor("#0F172A"),
        spaceBefore=4,
        spaceAfter=6
    )

    callout_style = ParagraphStyle(
        "CalloutStyle",
        fontName="ArabicArial",
        fontSize=10,
        leading=14,
        textColor=colors.HexColor("#92400E"),
        alignment=2
    )

    story = []

    # 1. Header Banner Box
    header_data = [
        [Paragraph(ar("مسار واستدعاء الـ API خطوة بخطوة في تطبيق Movie App"), ar_title_style)],
        [Paragraph(ar("شرح شامل لتدفق البيانات بحسب Clean Architecture من الواجهة إلى السيرفر والعودة"), ar_subtitle_style)],
        [Paragraph(ar("Movie App • Flutter BLoC / Cubit • Dio • Entity Mapping • Error Diagnosis"), ParagraphStyle("EnMeta", fontName="Helvetica-Bold", fontSize=9, alignment=1, textColor=colors.HexColor("#D97706")))]
    ]
    header_table = Table(header_data, colWidths=[523])
    header_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#0F172A")),
        ('PADDING', (0,0), (-1,-1), 14),
        ('ROUNDEDCORNERS', [10, 10, 10, 10]),
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
    ]))
    story.append(header_table)
    story.append(Spacer(1, 15))

    # 2. Architecture Overview
    story.append(Paragraph(ar("1. المخطط العام لدورة حياة الطلب (Request Lifecycle)"), ar_heading_style))
    story.append(Paragraph(ar("تعتمد معمارية الـ Clean Architecture على فصل المسؤوليات إلى 3 طبقات رئيسية، بحيث تعتمد الطبقات الخارجية على الطبقات الداخلية (اتجاه التدفق من Presentation إلى Domain ثم Data):"), ar_body_style))

    flow_table_data = [
        [Paragraph(ar("الطبقة / المكون"), ParagraphStyle("Th1", fontName="ArabicArial", fontSize=10, fontName_bold="ArabicArial", textColor=colors.white, alignment=2)),
         Paragraph(ar("الملف والمسؤولية"), ParagraphStyle("Th2", fontName="ArabicArial", fontSize=10, textColor=colors.white, alignment=2))],
        [Paragraph("1. Presentation\n(UI Screen)", code_style), Paragraph(ar("HomeScreen: تبدأ بطلب البيانات MovieCubit.fetchMovies() وتستمع لتغير الحالات (Loading, Error, Success)."), ar_body_style)],
        [Paragraph("2. Presentation\n(Cubit / State)", code_style), Paragraph(ar("MovieCubit: يُطلق MovieLoadingState فوراً، ثم يستدعي GetAllMovies UseCase."), ar_body_style)],
        [Paragraph("3. Domain\n(Use Case)", code_style), Paragraph(ar("GetAllMovies: يمثل منطق العمل (Business Logic)، ينفذ استدعاء repo.getAllMovie()."), ar_body_style)],
        [Paragraph("4. Domain\n(Repository Contract)", code_style), Paragraph(ar("MovieRepo: واجهة (Interface) مجردة تُحدد عقد إرجاع FutureResult<List<MovieEntity>>."), ar_body_style)],
        [Paragraph("5. Data\n(Repository Imp)", code_style), Paragraph(ar("MovieRepoImp: يُنسق بين الـ RemoteDataSource ويحوّل Models إلى Entities عبر toEntity()."), ar_body_style)],
        [Paragraph("6. Data\n(Remote DataSource)", code_style), Paragraph(ar("MovieRemoteDataSourceImpl: يرسل طلب HTTP عبر Dio إلى السيرفر الخارجي."), ar_body_style)],
        [Paragraph("7. External API", code_style), Paragraph(ar("https://movies-api.accel.li/api/v2/list_movies.json (يرجع بيانات JSON كاملة)."), ar_body_style)],
    ]
    t_flow = Table(flow_table_data, colWidths=[130, 393])
    t_flow.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#1E293B")),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.HexColor("#F8FAFC"), colors.HexColor("#FFFFFF")]),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('PADDING', (0,0), (-1,-1), 6),
    ]))
    story.append(t_flow)
    story.append(Spacer(1, 15))

    # 3. Step-by-Step Code Walkthrough
    story.append(Paragraph(ar("2. المسار التفصيلي بالكود خطوة بخطوة"), ar_heading_style))

    story.append(Paragraph(ar("الخطوة 1: انطلاق الطلب من الواجهة والـ Cubit"), ar_body_style))
    code_step1 = (
        "// HomeScreen.dart - حقن الـ Cubit وبدء الجلب\n"
        "BlocProvider(\n"
        "  create: (context) {\n"
        "    final remoteDataSource = MovieRemoteDataSourceImpl();\n"
        "    final repo = MovieRepoImp(remoteDataSource);\n"
        "    final getAllMoviesUseCase = GetAllMovies(repo);\n"
        "    return MovieCubit(getAllMoviesUseCase: getAllMoviesUseCase)..fetchMovies();\n"
        "  },\n"
        "  child: HomeScreenContent(),\n"
        ");"
    )
    code_table1 = Table([[Paragraph(code_step1.replace("\n", "<br/>"), code_style)]], colWidths=[523])
    code_table1.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(code_table1)
    story.append(Spacer(1, 10))

    story.append(Paragraph(ar("الخطوة 2: إدارة الحالة في الـ MovieCubit"), ar_body_style))
    code_step2 = (
        "// MovieCubit.dart - إدارة حالات التحميل والنتيجة\n"
        "Future<void> fetchMovies() async {\n"
        "  emit(MovieLoadingState()); // 1. إظهار مؤشر التحميل\n"
        "  final result = await getAllMoviesUseCase.call();\n"
        "  result.fold(\n"
        "    (failure) => emit(MovieErrorState(failure.message)), // في حالة الفشل\n"
        "    (movies) => emit(MovieSuccessState(movies)),         // في حالة النجاح\n"
        "  );\n"
        "}"
    )
    code_table2 = Table([[Paragraph(code_step2.replace("\n", "<br/>"), code_style)]], colWidths=[523])
    code_table2.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(code_table2)

    story.append(PageBreak())

    # Page 2: Data layer, Model mapping, Navigation
    story.append(Paragraph(ar("الخطوة 3: الاتصال بالإنترنت وجلب البيانات عبر Dio"), ar_heading_style))
    code_step3 = (
        "// movie_remote_data_source.dart - استدعاء الـ Endpoint وتحويل الـ JSON\n"
        "final response = await DioSevice.dio.get('https://movies-api.accel.li/api/v2/list_movies.json');\n"
        "if (response.statusCode == 200) {\n"
        "  final Map<String, dynamic> data = response.data is String\n"
        "      ? jsonDecode(response.data as String)\n"
        "      : (response.data as Map<String, dynamic>);\n"
        "  final movieModel = MovieModel.fromJson(data);\n"
        "  return movieModel.data?.movies ?? [];\n"
        "}"
    )
    code_table3 = Table([[Paragraph(code_step3.replace("\n", "<br/>"), code_style)]], colWidths=[523])
    code_table3.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(code_table3)
    story.append(Spacer(1, 10))

    story.append(Paragraph(ar("الخطوة 4: تحويل الـ Model إلى Entity (toEntity)"), ar_body_style))
    story.append(Paragraph(ar("وظيفة الـ Repository هي تحويل كائنات الـ Data Model إلى MovieEntity النظيفة لحماية شاشات التطبيق من التبعيات الخارجية:"), ar_body_style))
    code_step4 = (
        "// movie_model.dart -> MoviesExtension\n"
        "extension MoviesExtension on Movies {\n"
        "  MovieEntity toEntity() {\n"
        "    return MovieEntity(\n"
        "      id: id ?? 0,\n"
        "      title: title ?? '',\n"
        "      image: mediumCoverImage ?? largeCoverImage ?? '',\n"
        "      rating: rating ?? 0.0,\n"
        "      year: year ?? 0,\n"
        "      runtime: runtime ?? 0,\n"
        "      summary: (summary != null && summary!.isNotEmpty) ? summary! : (descriptionFull ?? ''),\n"
        "      genres: genres ?? const [],\n"
        "      backgroundImage: backgroundImageOriginal ?? backgroundImage ?? '',\n"
        "    );\n"
        "  }\n"
        "}"
    )
    code_table4 = Table([[Paragraph(code_step4.replace("\n", "<br/>"), code_style)]], colWidths=[523])
    code_table4.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(code_table4)
    story.append(Spacer(1, 10))

    story.append(Paragraph(ar("الخطوة 5: تمرير الفيلم إلى شاشة التفاصيل (MovieDetails)"), ar_heading_style))
    story.append(Paragraph(ar("عند النقر على أي فيلم في الشاشة الرئيسية يتم إرساله كـ argument واستقباله وعرض جميع تفاصيله:"), ar_body_style))
    code_step5 = (
        "// 1. الإرسال من HomeScreen:\n"
        "Navigator.pushNamed(context, RouteName.movieDatailsScreen, arguments: movie);\n\n"
        "// 2. الاستقبال في MovieDetails:\n"
        "final movie = ModalRoute.of(context)?.settings.arguments as MovieEntity?;\n\n"
        "// 3. الربط مع الودجات:\n"
        "MovieDetailsHeader(title: movie.title, year: movie.year.toString());\n"
        "MovieStatBadge(icon: Icons.star, label: movie.rating.toStringAsFixed(1));\n"
        "MovieStatBadge(icon: Icons.timer, label: '${movie.runtime}m');\n"
        "Text(movie.summary);"
    )
    code_table5 = Table([[Paragraph(code_step5.replace("\n", "<br/>"), code_style)]], colWidths=[523])
    code_table5.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F1F5F9")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#CBD5E1")),
        ('PADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(code_table5)
    story.append(Spacer(1, 15))

    # 4. Diagnostic Study of Unexpected Error
    story.append(Paragraph(ar("3. دراسة الخطأ السابق (Exception: Unexpected Error) وكيف حُل"), ar_heading_style))
    error_note = (
        "<b>" + ar("السبب الجذري:") + "</b> " +
        ar("في Dart، نوع int لا يتحول تلقائياً لـ double. عندما أرجع الـ API فيلم بتقييم 0 كـ int، تسبب سطر rating = json['rating'] في رمي:") +
        "<br/><code>type 'int' is not a subtype of type 'double?' in type cast</code><br/>" +
        "<b>" + ar("الحل الجذري المعتمد:") + "</b> " +
        ar("التحويل الآمن باستخدام num?:") +
        "<br/><code>rating = (json['rating'] as num?)?.toDouble();</code>"
    )
    error_table = Table([[Paragraph(error_note, callout_style)]], colWidths=[523])
    error_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#FEF3C7")),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#F59E0B")),
        ('PADDING', (0,0), (-1,-1), 10),
        ('ROUNDEDCORNERS', [6, 6, 6, 6]),
    ]))
    story.append(error_table)

    doc.build(story, canvasmaker=NumberedCanvas)
    print("PDF generated successfully at:", pdf_filename)

if __name__ == "__main__":
    build_pdf()
