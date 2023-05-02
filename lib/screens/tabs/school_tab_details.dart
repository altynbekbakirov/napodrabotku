import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ishtapp/datas/youtube_model.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:easy_localization/easy_localization.dart';

class SchoolTabDetails extends StatefulWidget {
  final int playList;

  SchoolTabDetails(this.playList);

  @override
  _SchoolTabDetailsState createState() => _SchoolTabDetailsState();
}

class _SchoolTabDetailsState extends State<SchoolTabDetails> {
  YoutubePlayerController _ytbPlayerController;
  List<YoutubeModel> videosList = [];

  List<String> titles = [
    (Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB")
        ? 'searching_work'.tr()
        : 'startup_lab'.tr(),
    'online_training_courses'.tr(),
    'artificial_intelligence'.tr(),
    'machine_learning'.tr(),
    'neural_networks'.tr(),
    'data_science'.tr(),
    'cyber_security'.tr(),
    'software_design'.tr(),
    'links_for_courses'.tr(),
  ];

  List<Links> links1 = [
    Links(
        title: 'Supply chain sustainability',
        link:
            'https://www.open.edu/openlearn/money-business/leadership-management/supply-chain-sustainability/content-section-0?active-tab=description-tab'),
    Links(
        title: 'An introduction to e-commerce and distributed applications',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/computing-ict/introduction-e-commerce-and-distributed-applications/content-section-0?active-tab=description-tab'),
    Links(
        title:
            'Supply Chain Management Arizona State University W. P. Carey School of Business',
        link:
            'https://www.classcentral.com/course/youtube-supply-chain-management-53095/classroom'),
    Links(
        title:
            'Supply Chain Management Academy for International Modern Studies (AIMS)',
        link: 'https://aims.education/supply-chain-management-notes/'),
    Links(
        title: 'Supply Chain Management (Full Course)',
        link: 'https://www.youtube.com/watch?v=gg6jW_PzKgg'),
    Links(
        title: 'Supply Chain Management Tutorials Point (India)',
        link:
            'https://www.youtube.com/watch?v=lbn8tohqnCQ&list=PLWPirh4EWFpGc-e-QwSCOEJAMf113SlYV'),
  ];

  List<Links> links2 = [
    Links(
        title: 'Developing career resilience',
        link:
            'https://www.open.edu/openlearn/money-business/developing-career-resilience/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Internships and other work experiences',
        link:
            'https://www.open.edu/openlearn/money-business/internships-and-other-work-experiences/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Personal branding for career success',
        link:
            'https://www.open.edu/openlearn/money-business/personal-branding-career-success/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Effective communication in the workplace',
        link:
            'https://www.open.edu/openlearn/money-business/effective-communication-the-workplace/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Working in diverse teams',
        link:
            'https://www.open.edu/openlearn/money-business/working-diverse-teams/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Job Search and Networking',
        link:
            'https://youtube.com/playlist?list=PLpQQipWcxwt9NO2SFW7n77KA8N6c1FRw3'),
    Links(
        title: 'Job Applications',
        link: 'https://edu.gcfglobal.org/en/jobapplications/'),
    Links(
        title: 'Interviewing Skills',
        link: 'https://edu.gcfglobal.org/en/interviewingskills/'),
    Links(
        title: 'Job Success', link: 'https://edu.gcfglobal.org/en/jobsuccess/'),
    Links(
        title: 'Career Planning and Salary',
        link:
            'https://youtube.com/playlist?list=PLpQQipWcxwt_jehepMBbfRr1U51dq35yB'),
    Links(
        title: 'Beginning a New Career',
        link:
            'https://www.youtube.com/playlist?list=PLpQQipWcxwt-2ttoq1OP-vi1hC3qbq6Sh'),
    Links(
        title: 'Search for a Part-Time or Summer Job',
        link:
            'https://applieddigitalskills.withgoogle.com/c/middle-and-high-school/en/search-for-a-part-time-or-summer-job/overview.html'),
    Links(
        title: 'Start a CV',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education-uk/en-uk/start-a-cv/overview.html'),
    Links(
        title: 'Start a Resume',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/start-a-resume/overview.html'),
    Links(
        title: 'Edit Your Resume',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/edit-your-resume/overview.html'),
    Links(
        title: 'Prepare for a Successful Job Interview',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/prepare-for-a-successful-job-interview/overview.html'),
    Links(
        title: 'Communicate Effectively at Work',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/effective-communications-at-work/overview.html'),
    Links(
        title: 'How to increase productivity at work',
        link:
            'https://learndigital.withgoogle.com/digitalgarage/course/increase-productivity'),
    Links(
        title: 'Prepare for Your First Day of Work',
        link:
            'https://applieddigitalskills.withgoogle.com/c/middle-and-high-school/en/prepare-for-your-first-day-of-work/overview.html'),
    Links(
        title: 'Build Your Professional Network',
        link:
            'https://applieddigitalskills.withgoogle.com/c/middle-and-high-school/en/build-your-professional-network/overview.html'),
    Links(
        title: 'Develop your career plan',
        link:
            'https://openclassrooms.com/en/courses/5291411-develop-your-career-plan'),
    Links(
        title: 'Develop your personal job search strategy',
        link:
            'https://openclassrooms.com/en/courses/5314701-develop-your-personal-job-search-strategy'),
    Links(
        title: 'Land a job',
        link: 'https://openclassrooms.com/en/courses/5370656-land-a-job'),
  ];

  List<Links> links3 = [
    Links(
        title: 'Making creativity and innovation happen',
        link:
            'https://www.open.edu/openlearn/money-business/making-creativity-and-innovation-happen/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Using data to aid organizational change',
        link:
            'https://www.open.edu/openlearn/money-business/using-data-aid-organisational-change/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Sustainable innovations in enterprises',
        link:
            'https://www.open.edu/openlearn/money-business/sustainable-innovations-enterprises/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Creativity', link: 'https://edu.gcfglobal.org/en/creativity/'),
    Links(
        title: 'Design in the World Around Us',
        link: 'https://edu.gcfglobal.org/en/design-in-the-world-around-us/'),
    Links(
        title: 'Develop Your Creativity',
        link:
            'https://openclassrooms.com/en/courses/6663471-develop-your-creativity'),
    Links(
        title: 'Learn About Design Thinking',
        link:
            'https://openclassrooms.com/en/courses/7459741-learn-about-design-thinking'),
    Links(
        title: 'Manage creative projects',
        link:
            'https://openclassrooms.com/en/courses/4555981-manage-creative-projects'),
  ];

  List<Links> links4 = [
    Links(
        title: 'You and your money',
        link:
            'https://www.open.edu/openlearn/money-business/personal-finance/you-and-your-money/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Academy of Money',
        link:
            'https://www.open.edu/openlearn/money-business/mses-academy-money/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Companies and financial accounting',
        link:
            'https://www.open.edu/openlearn/money-business/companies-and-financial-accounting/content-section-0?active-tab=description-tab'),
    Links(title: 'MoneyCoach', link: 'https://moneycoach.io/'),
    Links(
        title: 'Estimate Financing for Your Business Plan',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/estimate-financing-for-your-business-plan/overview.html'),
    Links(
        title: 'Track Your Monthly Expenses',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/track-your-monthly-expenses/overview.html'),
    Links(
        title: 'Plan and Budget',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/plan-and-budget/overview.html'),
    Links(
        title: 'Online Money Tips',
        link: 'https://edu.gcfglobal.org/en/online-money-tips/'),
    Links(
        title: 'Money Basics',
        link: 'https://edu.gcfglobal.org/en/moneybasics/'),
    Links(
        title:
            'Финансовая грамотность: 1 урок - Контроль финансов и ведение бюджета ',
        link: 'https://www.youtube.com/watch?v=TfQALmUyZ1E'),
    Links(
        title:
            'Финансовая грамотность 2 Урок: Финансовый контроль и разумная экономия.',
        link: 'https://www.youtube.com/watch?v=nTNLKnLM6ZY'),
    Links(
        title: 'Финансовая грамотность: 3 Урок - Денежный поток.',
        link: 'https://www.youtube.com/watch?v=_KN8dvtYaGY'),
    Links(
        title: 'Финансовая грамотность. 4 урок: Долги и кредиты',
        link: 'https://www.youtube.com/watch?v=FiCjm-KtMSU'),
    Links(
        title:
            'Финансовая грамотность. Урок 5: Как правильно копить деньги. Как откладывать.',
        link: 'https://www.youtube.com/watch?v=pjo-ncaLjh0'),
    Links(
        title: 'Зачем мы платим налоги?',
        link: 'https://www.youtube.com/watch?v=PT6aSe8cLqw'),
    Links(
        title: 'Выбор налогового режима в КР для малого бизнеса. ',
        link: 'https://www.youtube.com/watch?v=NaiRfOHJp5Q'),
    Links(
        title: 'Добровольный патент в Кыргызстане.',
        link: 'https://youtu.be/ZKnu_S6pu5I'),
    Links(
        title: 'Управленческий учет в КР',
        link: 'https://youtu.be/1WZkHYZ7Wg8'),
    Links(title: 'Учет для Бизнеса', link: 'https://youtu.be/_FqHxZJ6lCQ'),
    Links(
        title: 'Единая налоговая декларация',
        link: 'https://youtu.be/QevNcjE-VB4'),
    Links(
        title: 'Единая налоговая декларация – Все о налогах Кыргызстана',
        link: 'https://www.youtube.com/watch?v=dzX2L2Xflhc'),
  ];

  List<Links> links5 = [
    Links(
        title: 'Marketing in the 21st Century',
        link:
            'https://www.open.edu/openlearn/money-business/marketing-the-21st-century/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Social marketing',
        link:
            'https://www.open.edu/openlearn/money-business/business-strategy-studies/social-marketing/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Retail marketing',
        link:
            'https://www.open.edu/openlearn/money-business/business-strategy-studies/retail-marketing/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Marketing',
        link: 'https://www.youtube.com/watch?v=gDwslggSxUI'),
    Links(
        title: 'Create a Marketing Pitch Presentation',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/create-a-marketing-pitch-presentation/overview.html'),
    Links(
        title: 'Write a Press Release',
        link:
            'https://applieddigitalskills.withgoogle.com/c/middle-and-high-school/en/write-a-press-release/overview.html'),
    Links(
        title: 'Plan and Promote an Event',
        link:
            'https://applieddigitalskills.withgoogle.com/c/middle-and-high-school/en/plan-an-event/overview.html'),
    Links(
        title: 'Communicate your ideas through storytelling and design',
        link:
            'https://learndigital.withgoogle.com/digitalgarage/course/storytelling-design'),
    Links(
        title: 'Discover Digital Marketing',
        link:
            'https://openclassrooms.com/en/courses/6910726-discover-digital-marketing'),
    Links(
        title: 'Launch an Advertising Campaign',
        link:
            'https://openclassrooms.com/en/courses/6863126-launch-an-advertising-campaign'),
  ];

  List<Links> links6 = [
    Links(
        title: 'Design thinking',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/design-innovation/design-thinking/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Design',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/design-innovation/design/content-section-0?active-tab=description-tab'),
    Links(
        title: 'An introduction to design engineering',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/engineering-technology/an-introduction-design-engineering/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Visualization: visual representations of data and information',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/visualisation-visual-representations-data-and-information/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Manufacturing',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/design-innovation/manufacturing/content-section-0?active-tab=description-tab'),
    Links(
        title:
            'Designing the user interface: text, colour, images, moving images and sound',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/computing-ict/designing-the-user-interface-text-colour-images-moving-images-and-sound/content-section-0?active-tab=description-tab'),
    Links(
        title: 'An introduction to interaction design',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/an-introduction-interaction-design/content-section-0?active-tab=description-tab'),
    Links(
        title: 'People-centred designing',
        link:
            'https://www.open.edu/openlearn/science-maths-technology/engineering-and-technology/design-and-innovation/design/people-centred-designing/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Beginning Graphic Design',
        link:
            'https://www.youtube.com/playlist?list=PLpQQipWcxwt8vVzFpoJS5TtCh8Ktke9TH'),
    Links(
        title: 'Image Editing 101',
        link: 'https://edu.gcfglobal.org/en/imageediting101/'),
    Links(
        title: 'Create a Digital Picture Book',
        link:
            'https://applieddigitalskills.withgoogle.com/c/middle-and-high-school/en/create-a-digital-picture-book/overview.html'),
    Links(
        title: 'Design a Website to Promote a Project',
        link:
            'https://applieddigitalskills.withgoogle.com/c/middle-and-high-school/en/design-a-website-to-promote-a-project/overview.html'),
    Links(
        title: 'Dive into UX Design',
        link:
            'https://openclassrooms.com/en/courses/4555336-dive-into-ux-design'),
    Links(
        title: 'Design the visual side of experiences (UI design)',
        link:
            'https://openclassrooms.com/en/courses/4556206-design-the-visual-side-of-experiences-ui-design'),
  ];

  List<Links> links7 = [
    Links(
        title: 'A freelance career in the creative arts',
        link:
            'https://www.open.edu/openlearn/history-the-arts/a-freelance-career-the-creative-arts/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Freelance Work',
        link: 'https://edu.gcfglobal.org/en/freelance-work/'),
    Links(
        title: 'Build a sales strategy for your freelance business',
        link:
            'https://openclassrooms.com/en/courses/5327241-build-a-sales-strategy-for-your-freelance-business'),
    Links(
        title: 'Learn to freelance: daily management',
        link:
            'https://openclassrooms.com/en/courses/5566476-learn-to-freelance-daily-management'),
    Links(
        title: 'A freelance career in the creative arts',
        link:
            'https://www.open.edu/openlearn/history-the-arts/a-freelance-career-the-creative-arts/content-section-overview'),
  ];

  List<Links> links8 = [
    Links(
        title: 'Business models in strategic management',
        link:
            'https://www.open.edu/openlearn/money-business/business-models-strategic-management/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Understanding your customers',
        link:
            'https://www.open.edu/openlearn/money-business/understanding-your-customers/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Contemporary issues in managing',
        link:
            'https://www.open.edu/openlearn/money-business/contemporary-issues-managing/content-section-0?active-tab=description-tab'),
    Links(
        title: 'The importance of interpersonal skills',
        link:
            'https://www.open.edu/openlearn/money-business/leadership-management/the-importance-interpersonal-skills/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Exploring issues in women\'s health',
        link:
            'https://www.open.edu/openlearn/health-sports-psychology/exploring-issues-womens-health/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Collective leadership',
        link:
            'https://www.open.edu/openlearn/money-business/collective-leadership/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Leadership and followership',
        link:
            'https://www.open.edu/openlearn/education-development/learning/leadership-and-followership/content-section-overview?active-tab=description-tab'),
    Links(
        title: 'Rural entrepreneurship in Wales',
        link:
            'https://www.open.edu/openlearn/money-business/rural-entrepreneurship-wales/content-section-0?active-tab=description-tab'),
    Links(
        title: 'Write a Business Plan',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/write-a-business-plan/overview.html'),
    Links(
        title: 'Prepare For Your Business Plan',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education/en/prepare-for-your-business-plan/overview.html'),
    Links(
        title: 'Plan Effective Meetings',
        link:
            'https://applieddigitalskills.withgoogle.com/c/college-and-continuing-education-uk/en-uk/plan-effective-meetings/overview.html'),
    Links(
        title: 'Speaking in public',
        link:
            'https://learndigital.withgoogle.com/digitalgarage/course/public-speaking'),
    Links(
        title: 'Business communication',
        link:
            'https://learndigital.withgoogle.com/digitalgarage/course/business-communication'),
    Links(
        title: 'Intro to digital wellbeing',
        link:
            'https://learndigital.withgoogle.com/digitalgarage/course/digital-wellbeing'),
    Links(
        title: 'Business Communication',
        link: 'https://edu.gcfglobal.org/en/business-communication/'),
    Links(
        title: 'Speak in Public',
        link: 'https://openclassrooms.com/en/courses/5253451-speak-in-public'),
    Links(
        title: 'Learn How to Learn',
        link:
            'https://openclassrooms.com/en/courses/5281811-learn-how-to-learn'),
    Links(
        title: 'Develop your leadership for better management',
        link:
            'https://openclassrooms.com/en/courses/4312021-develop-your-leadership-for-better-management'),
    Links(
        title: 'Improve Your Presentation Skills',
        link:
            'https://openclassrooms.com/en/courses/5948166-improve-your-presentation-skills'),
    Links(
        title: 'Develop Your Critical Thinking',
        link:
            'https://openclassrooms.com/en/courses/7003486-develop-your-critical-thinking'),
    Links(
        title: 'Develop Your Soft Skills',
        link:
            'https://openclassrooms.com/en/courses/6951366-develop-your-soft-skills'),
    Links(
        title: 'Make Effective Decisions',
        link:
            'https://openclassrooms.com/en/courses/7035961-make-effective-decisions'),
    Links(
        title: 'Learn to work autonomously',
        link:
            'https://openclassrooms.com/en/courses/5291566-learn-to-work-autonomously'),
    Links(
        title: 'Learn how to network ',
        link:
            'https://openclassrooms.com/en/courses/5779841-learn-how-to-network'),
    Links(
        title: 'Decode the entrepreneur\'s DNA',
        link:
            'https://openclassrooms.com/en/courses/2709621-decode-the-entrepreneurs-dna'),
  ];

  @override
  void initState() {
    super.initState();

    if (Prefs.getString(Prefs.LANGUAGE) == 'ru') {
      switch (widget.playList) {
        case 0:
          if (Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB") {
            videosList = [
              YoutubeModel(
                  id: 1,
                  youtubeId: 'gaeMRAKrq24',
                  title: 'Мобильное приложение ishtapp'),
              YoutubeModel(
                  id: 2,
                  youtubeId: 'ckn_ACQV-Zk',
                  title: 'ishtapp - Регистрация для работодателей'),
              YoutubeModel(
                  id: 3,
                  youtubeId: 'lPttGkXzU9g',
                  title: 'ishtapp - Загрузка приложения и регистрация'),
              YoutubeModel(
                  id: 4,
                  youtubeId: 'ZbeHJ6xmDdw',
                  title: 'ishtapp - Заполнение резюме'),
              YoutubeModel(
                  id: 5,
                  youtubeId: 'dHXwfwx2Oc4',
                  title: 'ishtapp - Поиск вакансий'),
            ];
          } else {
            videosList = [
              YoutubeModel(
                  id: 1,
                  youtubeId: 'pCnylfLS6oY',
                  title: 'Запуск программы и все про Лабораторию Стартапов'),
              YoutubeModel(
                  id: 2,
                  youtubeId: 'OSFOMOFSw8I',
                  title: '"Моя мечта и Навыки 4К" от Лилии Утюшевой'),
              YoutubeModel(
                  id: 3,
                  youtubeId: 'OcRmQdLZ5J0',
                  title:
                      'Дивергентное и Конвергентное Мышление. Работа с эмоциями'),
              YoutubeModel(
                  id: 4,
                  youtubeId: 'xRAP31MJtK4',
                  title: 'Hard и Soft скиллы. Как управлять страхами?'),
              YoutubeModel(
                  id: 5,
                  youtubeId: 'wDEu7DMfhDI',
                  title: 'Работа в команде и Ответственность'),
              YoutubeModel(
                  id: 6,
                  youtubeId: 'H5AS5xcoi-w',
                  title: 'Что такое инновации и Цели Устойчивого Развития?'),
              YoutubeModel(
                  id: 7,
                  youtubeId: 'jsEfhz99UlA',
                  title: 'Введение в UpSHIFT. Дизайн Мышление и его Этапы?'),
              YoutubeModel(
                  id: 8,
                  youtubeId: 'A7DR4g6C3Pc',
                  title: 'Коины в лабаратории стартапов'),
              YoutubeModel(
                  id: 9,
                  youtubeId: 'IJNe4n9qfpg',
                  title:
                      'Инструменты для исследования пользователей и их эффективное применение'),
              YoutubeModel(
                  id: 10,
                  youtubeId: 'kRquZIgEEGI',
                  title: 'Карта пути пользователя'),
              YoutubeModel(
                  id: 11, youtubeId: 'fcI8ErT88Ho', title: 'Изучение Аналогов'),
              YoutubeModel(
                  id: 12,
                  youtubeId: 'De1bL3RfqNQ',
                  title: 'Метод Уолта Диснея для генерации идей и решений'),
              YoutubeModel(
                  id: 13,
                  youtubeId: 'XMmeV9X0r9M',
                  title: 'Прототипирование решений'),
              YoutubeModel(
                  id: 14,
                  youtubeId: 'FNKQUOzmuxA',
                  title: 'Тестирование прототипа на своей Целевой Аудитории'),
              YoutubeModel(
                  id: 15,
                  youtubeId: 'VdqAKKhYggs',
                  title: 'Бизнес модель Canvas бережливого стартапа'),
              YoutubeModel(
                  id: 16,
                  youtubeId: '3CNie-rgpVM',
                  title: 'Разработка продукта по Lean & Agile'),
              YoutubeModel(
                  id: 17,
                  youtubeId: 'GzEzYSXk_Tg',
                  title: 'Секреты успешного Питчинга'),
              YoutubeModel(
                  id: 18,
                  youtubeId: 'JFE51Y4diIk',
                  title: 'Секреты успешного питчинга'),
            ];
          }
          break;
        case 1:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: '0OQ1wz6j5B0',
                title: 'Управление цепочками поставок'),
            YoutubeModel(
                id: 2, youtubeId: 'QrC99pq7MaY', title: 'Маркетинг для ММСП'),
            YoutubeModel(
                id: 3,
                youtubeId: '-nYhk5PChss',
                title: 'Креативность и инновации'),
            YoutubeModel(
                id: 4, youtubeId: 'lP5AMt7e6qE', title: 'Графический дизайн'),
            YoutubeModel(
                id: 5,
                youtubeId: 'Jqv6WvxpiXI',
                title: 'Основы трудоустройства'),
            YoutubeModel(
                id: 6, youtubeId: '_LlCZQWQdmI', title: 'Введение во фриланс'),
            YoutubeModel(
                id: 7,
                youtubeId: 'JB803-1G2O4',
                title:
                    'Предпринимательство: маркетинговое исследование рынка и составление бизнес-плана'),
          ];
          break;
        case 2:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: 'snysEgofUc0',
                title: 'ОИИ 1 Введение в ИИ sub'),
            YoutubeModel(
                id: 2,
                youtubeId: '7oTlkD4Y7P0',
                title: 'ОИИ_2_История и развитие ИИ'),
            YoutubeModel(
                id: 3,
                youtubeId: 'ngcP9YCAHw0',
                title: 'ОИИ 3 Модели представления знаний sub'),
            YoutubeModel(
                id: 4,
                youtubeId: 'YI-E1ABj3es',
                title: 'ОИИ 4 Нечеткая логика sub'),
            YoutubeModel(
                id: 5,
                youtubeId: 'HLkHwqxMMCM',
                title: 'ОИИ 5 Экспертные системы sub'),
            YoutubeModel(
                id: 6,
                youtubeId: 'bfrHFEW9jFE',
                title: 'ОИИ_6_Восприятие и интеллект'),
            YoutubeModel(
                id: 7,
                youtubeId: '7_TCtj6cwZs',
                title: 'ОИИ 7 Машинное обучение sub'),
            YoutubeModel(
                id: 8,
                youtubeId: 'tOChkr3YIq4',
                title: 'ОИИ_8_Глубокое обучение и нейронные сети'),
            YoutubeModel(
                id: 9,
                youtubeId: 'ttkUbj148F0',
                title: 'ОИИ 9 Нейросетевые технологии sub'),
            YoutubeModel(
                id: 10,
                youtubeId: 'Xtgex3lrW8c',
                title: 'ОИИ_10_Алгоритмы в AI'),
            YoutubeModel(
                id: 11,
                youtubeId: 'Y8hwNT7EivI',
                title: 'ОИИ_11_Обработка естественного языкаNLP'),
            YoutubeModel(
                id: 12,
                youtubeId: 'YIwlKCfCJgc',
                title: 'ОИИ_12_Модель GPT 3 Проект Codex'),
            YoutubeModel(
                id: 13,
                youtubeId: '3TEHwCUDVLI',
                title: 'ОИИ_13_Беспилотный автомобиль ИИ и рабочие места'),
            YoutubeModel(
                id: 14,
                youtubeId: 'YvmsoEpnHOM',
                title:
                    'ОИИ_14_Структура интеллектуальной робототехнической системы'),
            YoutubeModel(
                id: 15,
                youtubeId: 'zfJLxxNBPSE',
                title: 'ОИИ 15 Аппаратное обеспечение в ИИ sub'),
            YoutubeModel(
                id: 16,
                youtubeId: 'qHsRZahDYbU',
                title: 'ОИИ 16 Заключение sub'),
          ];
          break;
        case 3:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: '5JiXlAkU-9M',
                title: 'МО_1_Что такое машинное обучение'),
            YoutubeModel(
                id: 2,
                youtubeId: 'Qy1wbWTfw34',
                title: 'МО_2_Контролируемое обучение'),
            YoutubeModel(
                id: 3,
                youtubeId: 'z3IC1UteSao',
                title: 'МО_4_Обучение с подкреплением'),
            YoutubeModel(
                id: 4,
                youtubeId: 'mf36WN6W-zc',
                title: 'МО_5_Математические основы'),
            YoutubeModel(
                id: 5,
                youtubeId: 'Cb7-8nxf5wM',
                title: 'МО_6_Введение в теорию вероятности'),
            YoutubeModel(
                id: 6,
                youtubeId: '55ItZg7zkkM',
                title: 'МО 7 Обзор линейной алгебры'),
          ];
          break;
        case 4:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: '8oVxFkOWp_M',
                title: 'НСиГО_1_Введение в НСиГО'),
            YoutubeModel(
                id: 2,
                youtubeId: 'imlMSCw4kbQ',
                title: 'НСиГО_2_Интуиция глубокого обучения'),
            YoutubeModel(
                id: 3, youtubeId: '2yWBNfZN5v8', title: 'НСиГО 3 Основы НС'),
            YoutubeModel(
                id: 4,
                youtubeId: 'Lp8OaZjweo8',
                title: 'НСиГО_4_Ключевые концепции глубоких НС'),
            YoutubeModel(
                id: 5,
                youtubeId: 'FEmbT8gJh1c',
                title: 'НСиГО 5 Глубокие НС sub'),
            YoutubeModel(
                id: 6,
                youtubeId: '1ViUN3cds7Y',
                title: 'НСиГО_6_Неглубокая нейронная сеть'),
            YoutubeModel(
                id: 7,
                youtubeId: 'HmW0Wvd-8HI',
                title: 'НСиГО 7 Практические аспекты ГО sub'),
            YoutubeModel(
                id: 8,
                youtubeId: 'oQ9VTMc_7Sk',
                title: 'НСиГО 8 Алгоритмы оптимизации sub'),
            YoutubeModel(
                id: 9,
                youtubeId: 'Xf5BpUN3ds4',
                title: 'НСиГО 9 ИИ и здравохранение sub'),
            YoutubeModel(
                id: 10,
                youtubeId: 'roDitV2Xr-s',
                title: 'НСиГО 10 Стратегия МО sub'),
            YoutubeModel(
                id: 11,
                youtubeId: 'neIGMTNHmWM',
                title: 'НСиГО 11 Стратегия МО 2 sub'),
            YoutubeModel(
                id: 12,
                youtubeId: '9MjxBr2xeb0',
                title: 'Сверточная нейронная сеть sub'),
            YoutubeModel(
                id: 13,
                youtubeId: 'HH_BHqMejJI',
                title: 'НСиГО 13 Рекурентные НС sub'),
            YoutubeModel(
                id: 14,
                youtubeId: 'xpBLy2VHr6w',
                title: 'НСиГО_14_Модели Sequence to Sequence'),
            YoutubeModel(
                id: 15,
                youtubeId: '4ZiZmQk3n-g',
                title: 'НСиГО 15 Глубокое обучение с подкреплением'),
            YoutubeModel(
                id: 16,
                youtubeId: '5Wh1WV_cV1g',
                title: 'НСиГО 16 Заключение sub'),
          ];
          break;
        case 5:
          videosList = [
            YoutubeModel(
                id: 1, youtubeId: '2vcPhHjmnmo', title: 'НоД_1_Наука о данных'),
            YoutubeModel(
                id: 2, youtubeId: '_xsTGPKdHDw', title: 'НоД 2 Типы данных2'),
            YoutubeModel(
                id: 3,
                youtubeId: 'f6EI4xvRs2I',
                title: 'НоД 3 Визуализация данных'),
            YoutubeModel(
                id: 4,
                youtubeId: 'Z1JSPD1qd-0',
                title: 'НоД_4_Принципы проектирования визуализации данных'),
            YoutubeModel(
                id: 5,
                youtubeId: 'QCbrdw6OaBk',
                title: 'НоД 5 Использование D3 js для визуализации данных'),
            YoutubeModel(
                id: 6,
                youtubeId: 'SK-POkScHWg',
                title: 'НоД_6_Веб приложения для визуализации дизайна'),
            YoutubeModel(
                id: 7,
                youtubeId: 'HDTpESDbrVs',
                title: 'НоД 7 Примеры визуализации на тестовых данных'),
            YoutubeModel(
                id: 8,
                youtubeId: '2EC09E2C1jM',
                title: 'НоД_8_Статистика и обработка данных'),
            YoutubeModel(
                id: 9,
                youtubeId: 'fxbFx42w6Vg',
                title: 'НоД 9 Введение в вероятность и статистику sub'),
            YoutubeModel(
                id: 10,
                youtubeId: 'n53ePj0NOcE',
                title: 'НоД 10 Кластеризация и классификация sub2'),
            YoutubeModel(
                id: 11,
                youtubeId: '-robfzZwWuI',
                title: 'НоД 11 Математическое моделирование в НоД'),
            YoutubeModel(
                id: 12,
                youtubeId: 'vv08PYzqZ7k',
                title: 'НоД 12 Вычислительные методы в науке о данных'),
            YoutubeModel(
                id: 13,
                youtubeId: 'unQqeyB6c6U',
                title: 'НоД 13 Использование Python для науки о данных'),
            YoutubeModel(
                id: 14,
                youtubeId: 'EQfZ_ekL3fg',
                title: 'НоД 14 Использование библиотеки R для науки о данных'),
            YoutubeModel(
                id: 15, youtubeId: 'BH2D4Y3tZ70', title: 'НоД 15 ПО в НоД sub'),
            YoutubeModel(
                id: 16, youtubeId: 'vcrh_kSoG6o', title: 'НоД 16 Заключение'),
          ];
          break;
        case 6:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: 'FnKMMotydpA',
                title: 'ТК_1_Информационная безопасность'),
            YoutubeModel(
                id: 2,
                youtubeId: 'b-LepZ5cWzM',
                title: 'ТК_2_Основы интернета и сети'),
            YoutubeModel(
                id: 3, youtubeId: 'cQ4zVrzhQy8', title: 'ТК_3_Криптография'),
            YoutubeModel(
                id: 4,
                youtubeId: 'HT8IXHC9y2Y',
                title: 'ТК 4 Поточные шифры sub'),
            YoutubeModel(
                id: 5,
                youtubeId: 'x-MHb-jQcQY',
                title: 'ТК 5 Блочные шифры sub'),
            YoutubeModel(
                id: 6,
                youtubeId: 'y_w7esmw9RE',
                title: 'ТК 6 Криптосистемы с открытым ключом sub'),
            YoutubeModel(id: 7, youtubeId: 'wtIbaMQU0Mg', title: 'ТК_7_Взлом'),
            YoutubeModel(
                id: 8,
                youtubeId: 'En8Ph28SE4U',
                title:
                    'ТК 8 10 самых часто встречающихся моделей угроз OWASP sub'),
            YoutubeModel(
                id: 9,
                youtubeId: 'UJgbn9NQM9s',
                title: 'ТК 9 Методы защиты от OWASP 10'),
            YoutubeModel(
                id: 10,
                youtubeId: 'nk7_28NLAUE',
                title: 'ТК_10_Социальная инженерия'),
            YoutubeModel(
                id: 11,
                youtubeId: 'hZIPBjmG5CU',
                title: 'ТК_11_Виды социальной инженерии'),
            YoutubeModel(
                id: 12,
                youtubeId: '2RtiRwYgRpA',
                title: 'ТК 12 Защита данных на бытовом уровне'),
            YoutubeModel(
                id: 13,
                youtubeId: '84py_5Yb2Ik',
                title: 'ТК_13_Реагирование на инциденты'),
            YoutubeModel(
                id: 14,
                youtubeId: 'vcGN7DDxsM0',
                title: 'ТК_14_Планы реагирования'),
            YoutubeModel(
                id: 15,
                youtubeId: '9B3GkxzNerM',
                title: 'ТК 15 Политика информационной безопасности sub2'),
            YoutubeModel(
                id: 16,
                youtubeId: 'FG7CiiUttcs',
                title: 'ТК 16 Заключение sub'),
          ];
          break;
        case 7:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: 'mIdA4E4boHU',
                title: 'ПиОБПО_1_Введение в проектирование ПО и безопасность'),
            YoutubeModel(
                id: 2,
                youtubeId: 'njKNyDsLGRc',
                title: 'ПиОБПО_2_Основы разработки ПО'),
            YoutubeModel(
                id: 3, youtubeId: 'ph99o6jaw1Y', title: 'ППиОБПО_3_Типы ПО'),
            YoutubeModel(
                id: 4,
                youtubeId: 'RCbRqpzfqn0',
                title: 'ПиОБПО_4_ПО с открытым кодом'),
            YoutubeModel(
                id: 5,
                youtubeId: 'Nw-WKAAPpp8',
                title: 'ПиОБПО_5_Архитектура ПО'),
            YoutubeModel(
                id: 6,
                youtubeId: 'vRp6WmiWgB0',
                title: 'ПиОБПО_6_UML и диаграммы классов'),
            YoutubeModel(
                id: 7,
                youtubeId: 'v3s2RFdDxY8',
                title: 'ПиОБПО_7_Веб приложения'),
            YoutubeModel(
                id: 8,
                youtubeId: '5fjD6nb9h5Q',
                title: 'ПиОБПО_8_Процесс проектирования'),
            YoutubeModel(
                id: 9,
                youtubeId: 'ZvnWifKHTt0',
                title: 'ПиОБПО_9_Процесс разработки'),
            YoutubeModel(
                id: 10,
                youtubeId: '9KNPv_887Ls',
                title: 'ПиОБПО_10_Гибкая разработка'),
            YoutubeModel(
                id: 11,
                youtubeId: 'TQd3rkF5zfw',
                title: 'ПиОБПО_11_Документирование'),
            YoutubeModel(
                id: 12,
                youtubeId: 'qb3LUJF41AM',
                title: 'ПиОБПО_12_Пользовательский интерфейс'),
            YoutubeModel(
                id: 13,
                youtubeId: '-4mAbqooasI',
                title: 'ПиОБПО_13_Основы безопасности ПО'),
            YoutubeModel(
                id: 14,
                youtubeId: 'Mjw-es3Dx60',
                title: 'ПиОБПО_14_Авторизация, аутентификация и аудит'),
            YoutubeModel(
                id: 15,
                youtubeId: 'RQw5QkOQYRA',
                title: 'ПиОБПО_15_Тестирование ПО'),
            YoutubeModel(
                id: 16,
                youtubeId: 'OEXcvkHIa00',
                title: 'ПиОБПО_16_Заключение'),
          ];
          break;
      }
    } else {
      switch (widget.playList) {
        case 0:
          if (Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB") {
            videosList = [
              YoutubeModel(
                  id: 1,
                  youtubeId: 'nuz9xfcrZd4',
                  title: 'ishtapp - Мобилдик колдномосу'),
              YoutubeModel(
                  id: 2,
                  youtubeId: '2EmR3v81X2M',
                  title: 'ishtapp - Вакансия издөө'),
              YoutubeModel(
                  id: 3,
                  youtubeId: 'A-AmIuAZhek',
                  title: 'ishtapp - Резюме толтуруу'),
              YoutubeModel(
                  id: 4,
                  youtubeId: 'G1Cb7xqjpFg',
                  title: 'ishtapp - Колдонмону жүктөп алуу жана катталуу'),
              YoutubeModel(
                  id: 5,
                  youtubeId: 'vamUDA7p3LU',
                  title: 'ishtapp - Иш берүүчү катары катталуу'),
            ];
          } else {
            videosList = [
              YoutubeModel(
                  id: 1,
                  youtubeId: 'np5-CHHDqvs',
                  title: 'Стартаптар Лабораториясы жонундо маалымат'),
              YoutubeModel(
                  id: 2,
                  youtubeId: 'fdyXypMmNlc',
                  title: 'Менин кыялым. 4К Кондумдору'),
              YoutubeModel(
                  id: 3,
                  youtubeId: 'vQ2rU71Kdnk',
                  title:
                      'Дивергенттуу жана конвергентуу ой жугуртуу. Сезимдер устундоо иштоо'),
              YoutubeModel(
                  id: 4,
                  youtubeId: 'VNibKv4ZQIM',
                  title:
                      'Hard жана Soft кондумдору. Коркунучтар устундо иштоо'),
              YoutubeModel(
                  id: 5,
                  youtubeId: 'xrHB_vSkTb0',
                  title:
                      'Жоопкерчилик жана командада иштоо жондомдуулугу. Лидерлик жондом'),
              YoutubeModel(
                  id: 6,
                  youtubeId: 'cWhELvLT9QY',
                  title:
                      'Инновация жана Туруктуу Онугуу Максаттары деген эмне?'),
              YoutubeModel(
                  id: 7,
                  youtubeId: 'O35dblVWxHM',
                  title: 'UpSHIFT. Дизайн Ой жугуртууго киришуу'),
              YoutubeModel(
                  id: 8,
                  youtubeId: 'SyCQq3eQjvM',
                  title:
                      'Колдонуучуларды изилдөө куралдары жана аларды эффективдүү колдонуу'),
              YoutubeModel(
                  id: 9,
                  youtubeId: '0MpO1KGdEaA',
                  title: 'Колдонуучулардын жол картасы'),
              YoutubeModel(
                  id: 10,
                  youtubeId: 'JNug9QyMEaM',
                  title: 'UStartдагы Коиндер'),
              YoutubeModel(
                  id: 11,
                  youtubeId: 'P5SPkdxQVXo',
                  title: 'Маселени чечүүнүн жолдору'),
              YoutubeModel(
                  id: 12,
                  youtubeId: 'oJZMet7Ft_s',
                  title: 'Прототипти тестирлоо'),
              YoutubeModel(
                  id: 13,
                  youtubeId: 'mnbwjGtVjsk',
                  title: 'Canvas үнөмдүү стартаптын бизнес модели'),
              YoutubeModel(
                  id: 14,
                  youtubeId: 'rRI1NwUmj04',
                  title: 'Продуктыны Lean & Agile боюнча иштеп чыгуу'),
              YoutubeModel(
                  id: 15,
                  youtubeId: '6YQ-MNvy6Mo',
                  title: 'Максаттуу аудиторияңызда прототипти сыноо'),
              YoutubeModel(
                  id: 16,
                  youtubeId: 'i_6fIZ6vCsI',
                  title:
                      'Социалдык инновацияларды монетизациялоо жана каржылоо'),
              YoutubeModel(
                  id: 17,
                  youtubeId: '3PzUaSUeMKU',
                  title: 'Чечимдерди прототиптөө. Кагаз прототиби'),
              YoutubeModel(
                  id: 18,
                  youtubeId: 'y3tVLsMNDdU',
                  title:
                      'Социалдык инновацияларды монетизациялоо жана каржылоо'),
              YoutubeModel(
                  id: 19,
                  youtubeId: 'sNg7lq0gxm0',
                  title: 'Ийгиликтүү питчинг сырлары'),
              YoutubeModel(
                  id: 20,
                  youtubeId: 'JFE51Y4diIk',
                  title: 'Секреты успешного питчинга'),
            ];
          }
          break;
        case 1:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: '7PFXpLvq09c',
                title: 'Жетекчилер үчүн финансылык сабаттуулук')
          ];
          break;
        case 2:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: 'w-BHocWFhak',
                title: 'ЖИ_1_Жасалма интеллекттин түшүнүктөрү'),
            YoutubeModel(
                id: 2,
                youtubeId: '1fgr2H6Jf_A',
                title: 'ЖИ_2_ЖИ тарыхы жана өнүгүшү'),
            YoutubeModel(
                id: 3,
                youtubeId: 'PQZeec3TKIo',
                title: 'ЖИ_3_Билимди чагылдыруу моделдери'),
            YoutubeModel(
                id: 4, youtubeId: 'hTuYWB16Oms', title: 'ЖИ_4_Бүдөмүк логика'),
            YoutubeModel(
                id: 5,
                youtubeId: 'I7Wa9YMu4PU',
                title: 'ЖИ_5_Эксперттик системалар'),
            YoutubeModel(
                id: 6,
                youtubeId: '9e4XGu2drGQ',
                title: 'ЖИ_6_Кабылдоо жана интеллект'),
            YoutubeModel(
                id: 7,
                youtubeId: '9WL0Xz9S94c',
                title: 'ЖИ_7_Машинанын үйрөнүүсү'),
            YoutubeModel(
                id: 8,
                youtubeId: 'jRNfxEGAH7E',
                title: 'ЖИ_8_Тереңдетилген үйрөнүү'),
            YoutubeModel(
                id: 9,
                youtubeId: '5zIPQCI66u8',
                title: 'ЖИ_9_Нейрондук тармак технологиялары'),
            YoutubeModel(
                id: 10,
                youtubeId: '-uCZaIGRuNA',
                title: 'ЖИ_10_ ЖИ алгоритмдери'),
            YoutubeModel(
                id: 11,
                youtubeId: 'kwccYXHFVKM',
                title: 'ЖИ_11_Табигый тилди иштетүү NLP'),
            YoutubeModel(
                id: 12, youtubeId: 'pkcFxxZ928I', title: 'ЖИ_12_GPT 3 модели'),
            YoutubeModel(
                id: 13,
                youtubeId: 'CpnTueP1AaQ',
                title: 'ЖИ_13_Айдоочусуз унаалар ЖИ жана жумуш орундары'),
            YoutubeModel(
                id: 14,
                youtubeId: 'GQJjh3btJNo',
                title: 'ЖИ_14_Акылдуу робот системасынын түзүмү'),
            YoutubeModel(
                id: 15, youtubeId: 'Oq0UycoyKsI', title: 'ЖИ_15_ЖИ жабдыктары'),
            YoutubeModel(
                id: 16, youtubeId: 'Bull2Mjzxq0', title: 'ЖИ_16_Жыйынтык'),
          ];
          break;
        case 3:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: '62UdUyHFP1o',
                title: 'МҮ_1_Машинанын үйрөнүүсү деген эмне'),
            YoutubeModel(
                id: 2,
                youtubeId: '6hy__6fjz_Y',
                title: 'МҮ_2_Көзөмөлдөнгөн үйрөнүү'),
            YoutubeModel(
                id: 3,
                youtubeId: 'bsFtpwLqra4',
                title: 'МҮ_3_Көзөмөлсүз үйрөнүү'),
            YoutubeModel(
                id: 4,
                youtubeId: 'IAOXijc7EoE',
                title: 'МҮ_4_Бышыкталган үйрөнүү'),
            YoutubeModel(
                id: 5,
                youtubeId: 'GMRU9NUiiw0',
                title: 'МҮ_5_Математикалык негиз'),
            YoutubeModel(
                id: 6,
                youtubeId: 'YHKIVr_8FG8',
                title: 'МҮ_6_Ыктымалдуулук теориясынын негиздери'),
            YoutubeModel(
                id: 7,
                youtubeId: 'Y76RKiordFg',
                title: 'МҮ_7_Сызыктуу алгебрага жөнүндө жалпы түшүнүктөр'),
            YoutubeModel(
                id: 8,
                youtubeId: 'XU8KqJwJkNM',
                title: 'МҮ_8_Бир өзгөрмөлүү сызыктуу регрессия'),
            YoutubeModel(
                id: 9,
                youtubeId: 'B0Ga3OU514E',
                title: 'МҮ_9_Бир нече өзгөрмөлүү сызыктуу регрессия'),
            YoutubeModel(
                id: 10,
                youtubeId: '8Iq4mvwMN8k',
                title: 'МҮ_10_Логистикалык регрессия'),
            YoutubeModel(
                id: 11, youtubeId: 'Wljn1FLZ7Vg', title: 'МҮ_11_Регуляризация'),
            YoutubeModel(
                id: 12, youtubeId: 'r1u3V3QrkBE', title: 'МҮ_12_Octave Matlab'),
            YoutubeModel(
                id: 13,
                youtubeId: 'BzRrkPGqAKw',
                title: 'МҮ_13_Нейрон тармактары'),
            YoutubeModel(
                id: 14,
                youtubeId: 'nUwWZue1-GA',
                title: 'МҮ_14_Машинанын үйрөнүү системасынын дизайны'),
            YoutubeModel(
                id: 15,
                youtubeId: 'NQt6LZwvNEA',
                title: 'МҮ_15_Жөлөк вектордук машиналар.'),
            YoutubeModel(
                id: 16, youtubeId: 'Up2aG2ySNuM', title: 'МҮ_16_Жыйынтык'),
          ];
          break;
        case 4:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: '3U9iY7nTMVc',
                title:
                    'НТ_1_Нейрондук тармактар жана тереңдетилген үйрөнүүнүн негиздери'),
            YoutubeModel(
                id: 2,
                youtubeId: 'ENMQpa-tMZQ',
                title: 'НТ_2_Тереңдетилген үйрөнүүнүн интуициясы'),
            YoutubeModel(
                id: 3,
                youtubeId: 'jBbJqZoVoyw',
                title: 'НТ_3_Нейрон тармагынын негиздери'),
            YoutubeModel(
                id: 4,
                youtubeId: 'Jkry61lK5CU',
                title: 'НТ_4_Тереңдетилген НТ боюнча негизги түшүнүктөр'),
            YoutubeModel(
                id: 5,
                youtubeId: 'a2N60Pt7KRY',
                title: 'НТ_5_Тереңдетилген нейрон тармактары'),
            YoutubeModel(
                id: 6,
                youtubeId: 'x8so7-Wj6OU',
                title: 'НТ 6 Тайкы нейрон тармагы'),
            YoutubeModel(
                id: 7,
                youtubeId: 'J4SjBN9NvF4',
                title: 'НТ 7 Тереңдетилген үйрөнүүнүн практикалык жактары'),
            YoutubeModel(
                id: 8,
                youtubeId: '0ChStX_ayw0',
                title: 'НТ 8 Оптималдаштыруу алгоритмдери'),
            YoutubeModel(
                id: 9,
                youtubeId: 'Uj4IxUgzygs',
                title: 'НТ 9 ЖИ жана саламаттыкты сактоо тармагы'),
            YoutubeModel(
                id: 10,
                youtubeId: 'ALgJW67BCiU',
                title: 'НТ 10 МҮ стратегиясы 1'),
            YoutubeModel(
                id: 11,
                youtubeId: 'WB7gIu-IS4E',
                title: 'НТ 11 МҮ стратегиясы 2'),
            YoutubeModel(
                id: 12,
                youtubeId: 'BWIFBrAtWNc',
                title: 'НТ 12 Конволюциялык нейрон тармагы'),
            YoutubeModel(
                id: 13,
                youtubeId: 'dicVvCTfu18',
                title: 'НТ 13 Рекурренттик нейрон тармагы'),
            YoutubeModel(
                id: 14,
                youtubeId: '5__gVMKtYBM',
                title: 'НТ 14 Sequence to Sequence моделдери'),
            YoutubeModel(
                id: 15,
                youtubeId: '6zxGwYmmJ48',
                title: 'НТ 15 Терең бышыкталган үйрөнүү'),
            YoutubeModel(
                id: 16, youtubeId: 'F1Md3_DvXb8', title: 'НТ_16 Жыйынтык'),
          ];
          break;
        case 5:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: 'qs1phaoiAAk',
                title: 'МИ_1_Маалымат илими деген эмне'),
            YoutubeModel(
                id: 2,
                youtubeId: '9vUaVKlQkRg',
                title: 'МИ_2_Маалыматтын түрлөрү'),
            YoutubeModel(
                id: 3,
                youtubeId: '0sLWbTTTELQ',
                title: 'МИ_3_Маалыматтарды визуализациялоо'),
            YoutubeModel(
                id: 4,
                youtubeId: 'aTV310Ii2OA',
                title:
                    'МИ_4_Маалыматтарды визуализациялоодо дизайн принциптери'),
            YoutubeModel(
                id: 5,
                youtubeId: 'SS0xxW8EDnU',
                title:
                    'МИ_5_Маалыматтарды визуализациялоо үчүн D3 jsти колдонуу'),
            YoutubeModel(
                id: 6,
                youtubeId: 'lw4vPl9AQHI',
                title: 'МИ_6_Визуализациялоо үчүн веб колдонмолор'),
            YoutubeModel(
                id: 7,
                youtubeId: '1oA0YqlQe1w',
                title: 'МИ_7_Тест маалыматтар менен визуализациялоо өрнөктөрү'),
            YoutubeModel(
                id: 8,
                youtubeId: 'RaHwZfgZzIY',
                title: 'МИ_8_Статистика жана маалыматтарды иштетүү'),
            YoutubeModel(
                id: 9,
                youtubeId: 'Gnknvp1Y8E8',
                title: 'МИ_9_Ыктымалдуулук жана статистика негиздери'),
            YoutubeModel(
                id: 10,
                youtubeId: '7H01-vTP1yw',
                title: 'МИ_10_Кластерлөө жана классификация'),
            YoutubeModel(
                id: 11,
                youtubeId: 'ENIxAL3BEvY',
                title: 'МИ_11_Маалымат илиминде математикалык моделдөө'),
            YoutubeModel(
                id: 12,
                youtubeId: 'jJDm-MhPAcQ',
                title: 'МИ_12_Маалымат илими үчүн эсептөө ыкмалары'),
            YoutubeModel(
                id: 13,
                youtubeId: 'cVEY0RcRqnE',
                title: 'МИ_13_Маалымат илиминде Python колдонуу'),
            YoutubeModel(
                id: 14,
                youtubeId: 'wbf4pQfDW8c',
                title: 'МИ_14_Маалымат илиминде R китепканасын колдонуу'),
            YoutubeModel(
                id: 15,
                youtubeId: 'NZNviajhRA8',
                title: 'МИ_15_Маалымат илиминде программалык камсыздоолор'),
            YoutubeModel(
                id: 16, youtubeId: '5rROkfS65HA', title: 'МИ_16_Жыйынтык'),
          ];
          break;
        case 6:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: 'NzTEZfEzkiU',
                title: 'КТ_1_Маалымат коопсуздугу'),
            YoutubeModel(
                id: 2,
                youtubeId: 'xp9jiFdcZCU',
                title: 'КТ_2_Интернет жана компьютер тармактарынын негиздери'),
            YoutubeModel(
                id: 3, youtubeId: 'E7ypPdFCRfQ', title: 'КТ_3_Криптография'),
            YoutubeModel(
                id: 4, youtubeId: 'YiVhBfRIRI4', title: 'КТ_4_Агым шифрлери'),
            YoutubeModel(
                id: 5, youtubeId: 'nF6SjhD96G4', title: 'КТ_5_Блок шифрлери'),
            YoutubeModel(
                id: 6,
                youtubeId: 'WBbgDKc3hOw',
                title: 'КТ_6_Ачык ачкыч крипто системалары'),
            YoutubeModel(id: 7, youtubeId: 'USbjDsbKDfs', title: 'КТ_7_Бузуу'),
            YoutubeModel(
                id: 8,
                youtubeId: 'hAlCEMIjuqg',
                title: 'КТ_8_10 эң кеңири тараган OWASP коркунуч моделдери'),
            YoutubeModel(
                id: 9,
                youtubeId: 'ZDV7vOZ_duw',
                title: 'КТ_9_OWASP 10дон коргонуу ыкмалары'),
            YoutubeModel(
                id: 10,
                youtubeId: '6FuG8EXWx8I',
                title: 'КТ_10_Социалдык инженерия'),
            YoutubeModel(
                id: 11,
                youtubeId: 'jqsqs2ez7p8',
                title: 'КТ_11 Социалдык инженериянын түрлөрү'),
            YoutubeModel(
                id: 12,
                youtubeId: '307qV__Wg1I',
                title: 'КТ_12 Күнүмдүк жашоо маалыматтарын коргоо'),
            YoutubeModel(
                id: 13,
                youtubeId: 't7PP4B7u6bk',
                title: 'КТ_13 Инциденттерге реакция'),
            YoutubeModel(
                id: 14,
                youtubeId: 'qjaWdvmsHIQ',
                title: 'КТ_14 Реакция пландары'),
            YoutubeModel(
                id: 15,
                youtubeId: 'yT3xa6LEkWA',
                title: 'КТ_15_Маалымат коопсуздугу саясаты'),
            YoutubeModel(
                id: 16, youtubeId: '2OTLm2xn-EI', title: 'КТ_16 Жыйынтык'),
          ];
          break;
        case 7:
          videosList = [
            YoutubeModel(
                id: 1,
                youtubeId: '_CAT-Q4cY8Y',
                title: 'ПКД_1_ПК дизайны жана коопсуздугуна киришүү'),
            YoutubeModel(
                id: 2,
                youtubeId: 'rQX8F04MPD4',
                title: 'ПКД_2_ПК дизайнынын негиздери'),
            YoutubeModel(
                id: 3,
                youtubeId: 'vYd6uM5HCYA',
                title: 'ПКД_3_Программалык камсыздоонун түрлөрү'),
            YoutubeModel(
                id: 4,
                youtubeId: 'XS1n-5Ze5N4',
                title: 'ПКД_4_Коду ачык программалар'),
            YoutubeModel(
                id: 5,
                youtubeId: 'NqaCO68aOUA',
                title: 'ПКД_5_Программалык камсыздоонун архитектурасы'),
            YoutubeModel(
                id: 6,
                youtubeId: 'col80nHtJ2U',
                title: 'ПКД_6_UML жана класстардын диаграммалары'),
            YoutubeModel(
                id: 7,
                youtubeId: 'rOsWiJygrmA',
                title: 'ПКД_7_Веб колдонмолору'),
            YoutubeModel(
                id: 8,
                youtubeId: 'H5xeNU9uhaQ',
                title: 'ПКД_8_Дизайн ишинин жүрүшү'),
            YoutubeModel(
                id: 9,
                youtubeId: 'RPDR2dZJ4BQ',
                title: 'ПКД_9_Иштеп чыгуунун жүрүшү'),
            YoutubeModel(
                id: 10, youtubeId: 'qJy5Qtjr368', title: 'ПКД_10_Agile иштөө'),
            YoutubeModel(
                id: 11,
                youtubeId: 'QfgbCp1xTXA',
                title: 'ПКД_11_Документтештирүү'),
            YoutubeModel(
                id: 12,
                youtubeId: 'N7WkB5gjRs4',
                title: 'ПКД_12_Колдонуучу интерфейси'),
            YoutubeModel(
                id: 13,
                youtubeId: 'StudfvRBlXs',
                title: 'ПКД_13_Программалык камсыздоонун коопсуздук негиздери'),
            YoutubeModel(
                id: 14,
                youtubeId: '6NVl7grmLy4',
                title:
                    'ПКД_14_Авторизация, аутентификация жана каттоону жүргүзүү'),
            YoutubeModel(
                id: 15,
                youtubeId: 'wJUsr0E553U',
                title: 'ПКД_15_Программалык камсыздоону сыноо'),
            YoutubeModel(
                id: 16, youtubeId: 'n92NxvbP2zQ', title: 'ПКД_16_Жыйынтык'),
          ];
          break;
      }
    }

    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (widget.playList < 8) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _ytbPlayerController = YoutubePlayerController(
            initialVideoId: videosList[0].youtubeId,
            params: YoutubePlayerParams(
              showFullscreenButton: true,
            ),
          );
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (widget.playList < 8) {
      _ytbPlayerController.close();
    }
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[widget.playList]),
      ),
      body: widget.playList < 8
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildYtbView(),
                    SizedBox(height: 10),
                    _buildMoreVideosView(),
                  ]),
            )
          : _buildOnlineCoursesLinksView(),
    );
  }

  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _ytbPlayerController != null
          ? YoutubePlayerIFrame(controller: _ytbPlayerController)
          : Center(child: CircularProgressIndicator()),
    );
  }

  _buildMoreVideosView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            itemCount: videosList.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final _newCode = videosList[index].youtubeId;
                  _ytbPlayerController.load(_newCode);
                  _ytbPlayerController.stop();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  margin: EdgeInsets.symmetric(vertical: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://img.youtube.com/vi/${videosList[index].youtubeId}/0.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 8, bottom: 8, top: 6),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                videosList[index].title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.amber,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                              )),
                          bottom: 0,
                          left: 0,
                          right: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  _buildOnlineCoursesLinksView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'supply_chain_management'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links1.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links1[index].title, links1[index].link);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'employment_basics'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links2.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links2[index].title, links2[index].link);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'creativity_and_innovation'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links3.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links3[index].title, links3[index].link);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'financial_literacy'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links4.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links4[index].title, links4[index].link);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'msme_marketing'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links5.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links5[index].title, links5[index].link);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'graphic_design'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links6.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links6[index].title, links6[index].link);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'introduction_to_freelancing'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links7.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links7[index].title, links7[index].link);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).dividerColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'market_research_and_business_plan_development'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: links8.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(links8[index].title, links8[index].link);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, String link) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        link,
        style: TextStyle(fontSize: 12),
      ),
      trailing: Icon(Icons.link),
      onTap: () {
        launch(link);
      },
    );
  }
}

class Links {
  final String title;
  final String link;

  Links({this.title, this.link});
}
