//
//@RestController
//@RequestMapping("/api/bins")
//@CrossOrigin(origins = "*") // Cho phép Android app gọi API
//public class BinAppController {
//    @Autowired
//    private  BinService binService;
//
//    @Autowired
//    private BinRepository binRepository;
//
//    // Lấy danh sách tất cả thùng rác
//    @GetMapping
//    public List<Bin> getAllBins() {
//        return binService.getAllBins();
//    }
//
//
//
//    // Lấy chi tiết 1 thùng theo ID
//    @GetMapping("/{id}")
//    public Bin getBinById(@PathVariable int id) {
//        return binService.getBinById(id);
//    }
//
//    @GetMapping("/dto")
//    public List<BinDTO> getAllBinDTOs() {
//        List<Bin> bins = binRepository.findAll();
//        List<BinDTO> result = new ArrayList<>();
//
//        for (Bin bin : bins) {
//            String wardName = (bin.getWard() != null) ? bin.getWard().getWardName() : null;
//            String provinceName = (bin.getWard() != null && bin.getWard().getProvince() != null)
//                    ? bin.getWard().getProvince().getProvinceName()
//                    : null;
//
//            result.add(new BinDTO(
//                    bin.getBinID(),
//                    bin.getBinCode(),
//                    bin.getLatitude(),
//                    bin.getLongitude(),
//                    bin.getCapacity(),
//                    bin.getCurrentFill(),
//                    bin.getStreet(),
//                    wardName,
//                    provinceName,
//                    bin.getStatus(),
//                    bin.getLastUpdated()
//            ));
//        }
//
//        return result;
//    }
//
//}
//
