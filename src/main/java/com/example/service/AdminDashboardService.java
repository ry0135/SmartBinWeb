package com.example.service;

import com.example.model.Ward;
import com.example.repository.BinRepository;
import com.example.repository.WardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminDashboardService {

    @Autowired
    private BinRepository binRepository;

    @Autowired
    private WardRepository wardRepository;

    public long getTotalBins() {
        return binRepository.countAllBins();
    }

    public long getActiveBins() {
        return binRepository.countActiveBins();
    }

    public long getFullBins() {
        return binRepository.countFullBins();
    }

    public long getTotalWards() {
        return wardRepository.countAllWards();
    }
    public List<Object[]> getBinsAddedPerMonth() {
        return binRepository.countBinsAddedPerMonth();
    }

    public Object[] getBinStatusSummary() {
        List<Object[]> result = binRepository.countBinStatusSummary();
        if (result != null && !result.isEmpty()) {
            return result.get(0); // Lấy dòng đầu tiên
        }
        return new Object[]{0, 0, 0};
    }
    // 👉 Thêm hàm này để lấy danh sách phường
    public List<Ward> getAllWards() {
        return wardRepository.findAllWards();
    }
    public Map<String, Object> getDashboardData(Integer wardId) {
        Map<String, Object> data = new HashMap<>();

        if (wardId != null) {
            data.put("totalBins", binRepository.countBinsByWard(wardId));
            data.put("activeBins", binRepository.countActiveBinsByWard(wardId));
            data.put("fullBins", binRepository.countFullBinsByWard(wardId));
            data.put("binsPerMonth", binRepository.countBinsAddedPerMonthByWard(wardId));

            List<Object[]> summaryList = new ArrayList<>();
            summaryList.add(binRepository.countBinStatusSummaryByWard(wardId));
            data.put("binStatusSummary", summaryList.get(0));
        } else {
            data.put("totalBins", binRepository.countAllBins());
            data.put("activeBins", binRepository.countActiveBins());
            data.put("fullBins", binRepository.countFullBins());
            data.put("binsPerMonth", binRepository.countBinsAddedPerMonth());

            data.put("binStatusSummary", getBinStatusSummary());
        }

        data.put("totalWards", wardRepository.countAllWards());
        data.put("wards", wardRepository.findAllWards());

        return data;
    }




}
