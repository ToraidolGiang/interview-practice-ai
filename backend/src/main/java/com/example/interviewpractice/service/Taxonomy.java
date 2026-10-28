package com.example.interviewpractice.service;

import java.util.List;
import java.util.Map;

import com.example.interviewpractice.dto.ErrorResponse;

/**
 * Danh mục ngành/vị trí taxonomy-v1.0 (docs/business/Danh_Muc_Nganh_Vi_Tri.md). Phải khớp
 * frontend/src/constants/taxonomy.js; đổi danh mục thì sửa cả hai nơi và tăng phiên bản trong tài liệu.
 */
public final class Taxonomy {

    public static final String VERSION = "taxonomy-v1.0";

    private static final Map<String, List<String>> POSITIONS_BY_INDUSTRY = Map.of(
            "IT", List.of("Chung", "Backend Developer", "Frontend Developer", "Fullstack Developer",
                    "Mobile Developer", "Tester / QA", "DevOps / Quản trị hệ thống", "Data Analyst",
                    "Data Scientist / AI", "Business Analyst"),
            "Marketing", List.of("Chung", "Digital Marketing", "Content Marketing", "Chuyên viên SEO"),
            "Kinh doanh / Bán hàng", List.of("Chung", "Nhân viên kinh doanh", "Nhân viên bán hàng"),
            "Kế toán / Tài chính", List.of("Chung", "Kế toán viên", "Chuyên viên phân tích tài chính"),
            "Nhân sự", List.of("Chung", "Chuyên viên tuyển dụng", "Chuyên viên C&B"),
            "Chăm sóc khách hàng", List.of("Chung", "Nhân viên CSKH"));

    private Taxonomy() {
    }

    /** Trả về lỗi theo trường; rỗng nếu cặp ngành/vị trí hợp lệ. Giá trị so khớp nguyên văn, kể cả dấu và hoa thường. */
    public static List<ErrorResponse.FieldError> validate(String industry, String position) {
        List<String> positions = POSITIONS_BY_INDUSTRY.get(industry);
        if (positions == null) {
            return List.of(new ErrorResponse.FieldError("industry", "Ngành không có trong danh mục"));
        }
        if (!positions.contains(position)) {
            return List.of(new ErrorResponse.FieldError("position", "Vị trí không thuộc ngành " + industry));
        }
        return List.of();
    }
}
