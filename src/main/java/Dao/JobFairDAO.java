package Dao;

import java.util.ArrayList;
import java.util.List;
import java.net.URLEncoder;

import Vo.JobFairVo;
import Vo.JobPostingVo;

public class JobFairDAO {

    public List<JobFairVo> getJobFairList() {
        List<JobFairVo> list = new ArrayList<JobFairVo>();

        list.add(new JobFairVo(
                1,
                "삼성전자",
                "삼성전자 채용상담회",
                "2026-05-12",
                "학생회관 1층",
                "서울특별시 종로구 대학로 101 학생회관 1층",
                "반도체, SW, AI 직무 중심 채용상담이 진행됩니다.",
                "https://www.samsung.com/sec/",
                "https://www.samsungcareers.com/",
                buildKakaoMapUrl("서울특별시 종로구 대학로 101 학생회관 1층"),
                "A-01"
        ));

        list.add(new JobFairVo(
                2,
                "NAVER",
                "NAVER 채용설명회",
                "2026-05-14",
                "공학관 로비",
                "서울특별시 성북구 안암로 145 공학관 로비",
                "개발, 데이터, 서비스 기획 직무 관련 설명회입니다.",
                "https://www.naver.com/",
                "https://recruit.navercorp.com/",
                buildKakaoMapUrl("서울특별시 성북구 안암로 145 공학관 로비"),
                "B-03"
        ));

        list.add(new JobFairVo(
                3,
                "카카오",
                "카카오 캠퍼스 리크루팅",
                "2026-05-15",
                "중앙도서관 앞",
                "서울특별시 성북구 안암로 145 중앙도서관 앞",
                "플랫폼, 백엔드, 프론트엔드 직군 상담이 가능합니다.",
                "https://www.kakaocorp.com/",
                "https://careers.kakao.com/",
                buildKakaoMapUrl("서울특별시 성북구 안암로 145 중앙도서관 앞"),
                "C-02"
        ));

        list.add(new JobFairVo(
                4,
                "LG CNS",
                "LG CNS 채용 박람회",
                "2026-05-16",
                "체육관 앞 광장",
                "서울특별시 성북구 안암로 145 체육관 앞 광장",
                "클라우드, DX, AI 분야 채용상담이 진행됩니다.",
                "https://www.lgcns.com/",
                "https://www.lgcns.com/careers/",
                buildKakaoMapUrl("서울특별시 성북구 안암로 145 체육관 앞 광장"),
                "D-05"
        ));

        return list;
    }

    public List<JobPostingVo> getJobPostingList(int fairNo) {
        List<JobPostingVo> list = new ArrayList<JobPostingVo>();

        if (fairNo == 1) {
            list.add(new JobPostingVo(1, 1, "삼성전자", "SW 개발자 모집", "개발", "2026-06-01", "https://www.samsungcareers.com/"));
            list.add(new JobPostingVo(2, 1, "삼성전자", "AI 연구원 모집", "연구", "2026-06-05", "https://www.samsungcareers.com/"));
        } else if (fairNo == 2) {
            list.add(new JobPostingVo(3, 2, "NAVER", "백엔드 개발자 모집", "개발", "2026-06-03", "https://recruit.navercorp.com/"));
            list.add(new JobPostingVo(4, 2, "NAVER", "데이터 분석가 모집", "데이터", "2026-06-07", "https://recruit.navercorp.com/"));
        } else if (fairNo == 3) {
            list.add(new JobPostingVo(5, 3, "카카오", "프론트엔드 개발자 모집", "개발", "2026-06-10", "https://careers.kakao.com/"));
            list.add(new JobPostingVo(6, 3, "카카오", "서비스 기획자 모집", "기획", "2026-06-12", "https://careers.kakao.com/"));
        } else if (fairNo == 4) {
            list.add(new JobPostingVo(7, 4, "LG CNS", "클라우드 엔지니어 모집", "인프라", "2026-06-08", "https://www.lgcns.com/careers/"));
            list.add(new JobPostingVo(8, 4, "LG CNS", "DX 컨설턴트 모집", "컨설팅", "2026-06-15", "https://www.lgcns.com/careers/"));
        }

        return list;
    }

    public JobFairVo getJobFairDetail(int fairNo) {
        List<JobFairVo> list = getJobFairList();

        for (JobFairVo vo : list) {
            if (vo.getFairNo() == fairNo) {
                return vo;
            }
        }

        return null;
    }

    private String buildKakaoMapUrl(String address) {
        try {
            return "https://map.kakao.com/?q=" + URLEncoder.encode(address, "UTF-8");
        } catch (Exception e) {
            return "https://map.kakao.com/";
        }
    }
}