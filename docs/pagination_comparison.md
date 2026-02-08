# الفرق بين Infinite Scroll وزر "تحميل المزيد"

## 📊 المقارنة

| الميزة | Infinite Scroll | زر "تحميل المزيد" |
|--------|----------------|-------------------|
| **Widget** | `ApiViewPaginated` | `ApiViewPaginatedWithButton` |
| **التحميل** | تلقائي عند السكرول | يدوي بالضغط على الزر |
| **ScrollController** | مطلوب | غير مطلوب |
| **تجربة المستخدم** | سلسة ومستمرة | المستخدم يتحكم |
| **الأداء** | قد يحمل بيانات غير مطلوبة | يحمل فقط عند الطلب |

---

## 🔄 Infinite Scroll (الحالي)

### الكود المسؤول

في [`api_view_paginated.dart`](file:///Users/alashiq/2026/StarterApp/starter/lib/core/widgets/view/api_view_paginated.dart):

```dart
// السطر 36-39: إنشاء ScrollController
@override
void initState() {
  super.initState();
  _scrollController = ScrollController();
  _scrollController.addListener(_onScroll); // ← الاستماع للسكرول
}

// السطر 49-80: دالة _onScroll
void _onScroll() {
  if (_isLoadingMore) return;

  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.position.pixels;
  final delta = 200.0; // ← تحميل قبل 200 بكسل من النهاية

  if (currentScroll >= (maxScroll - delta)) { // ← الشرط
    final state = widget.state;
    if (state is ApiPaginatedSuccess<T>) {
      if (!state.meta.isLastPage) {
        _isLoadingMore = true;
        widget.onLoadMore(); // ← استدعاء تحميل المزيد
        // ...
      }
    }
  }
}
```

### الاستخدام

```dart
ApiViewPaginated<CityPaginatedModel>(
  state: controller.cityPaginatedState.value,
  onReload: () {
    controller.resetPagination();
    controller.loadPaginatedCity();
  },
  onLoadMore: () => controller.loadPaginatedCity(isLoadMore: true),
  builder: (cities, scrollController) {
    return ListView.builder(
      controller: scrollController, // ← مهم!
      itemCount: cities.length,
      itemBuilder: (context, index) => CityCard(city: cities[index]),
    );
  },
)
```

---

## 🔘 زر "تحميل المزيد" (الجديد)

### الملف الجديد

[`api_view_paginated_with_button.dart`](file:///Users/alashiq/2026/StarterApp/starter/lib/core/widgets/view/api_view_paginated_with_button.dart)

### الكود المسؤول

```dart
Widget _buildSuccess(List<T> data, meta) {
  return Column(
    children: [
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            onReload();
            await Future.delayed(const Duration(seconds: 1));
          },
          child: builder(data),
        ),
      ),
      // ← الزر هنا
      if (!meta.isLastPage)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: onLoadMore, // ← استدعاء تحميل المزيد
            icon: const Icon(Icons.arrow_downward),
            label: Text('تحميل المزيد (${meta.currentPage}/${meta.lastPage})'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
    ],
  );
}
```

### الاستخدام

```dart
ApiViewPaginatedWithButton<CityPaginatedModel>(
  state: controller.cityPaginatedState.value,
  onReload: () {
    controller.resetPagination();
    controller.loadPaginatedCity();
  },
  onLoadMore: () => controller.loadPaginatedCity(isLoadMore: true),
  builder: (cities) { // ← لاحظ: بدون scrollController
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) => CityCard(city: cities[index]),
    );
  },
)
```

---

## 🎯 كيف تختار؟

### استخدم **Infinite Scroll** عندما:
- ✅ المحتوى مثل feed أو timeline
- ✅ تريد تجربة سلسة ومستمرة
- ✅ المستخدم يتصفح بشكل عشوائي

### استخدم **زر "تحميل المزيد"** عندما:
- ✅ البيانات ثقيلة (صور، فيديوهات)
- ✅ تريد توفير data usage
- ✅ المستخدم يحتاج التحكم في التحميل
- ✅ تريد عرض معلومات الصفحة بوضوح

---

## 📝 مثال: تحويل الصفحة الحالية

لتحويل صفحة المدن من infinite scroll إلى زر:

```dart
// في city_paginated_screen.dart
import 'package:starter/core/widgets/view/api_view_paginated_with_button.dart';

// استبدل ApiViewPaginated بـ ApiViewPaginatedWithButton
ApiViewPaginatedWithButton<CityPaginatedModel>(
  state: controller.cityPaginatedState.value,
  onReload: () {
    controller.resetPagination();
    controller.loadPaginatedCity();
  },
  onLoadMore: () => controller.loadPaginatedCity(isLoadMore: true),
  builder: (cities) { // ← احذف scrollController من هنا
    return ListView.separated(
      // controller: scrollController, ← احذف هذا السطر
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: cities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final city = cities[index];
        return _CityCard(city: city, index: index);
      },
    );
  },
)
```

---

## 🔧 تخصيص إضافي

### تغيير المسافة في Infinite Scroll

في `api_view_paginated.dart` السطر 54:

```dart
final delta = 200.0; // ← غير هذا الرقم
// 0 = عند الوصول للنهاية تماماً
// 200 = قبل النهاية بـ 200 بكسل
// 500 = قبل النهاية بـ 500 بكسل
```

### تخصيص شكل الزر

في `api_view_paginated_with_button.dart` السطر 81-92، يمكنك تغيير:
- النص
- الأيقونة
- الألوان
- الحجم
