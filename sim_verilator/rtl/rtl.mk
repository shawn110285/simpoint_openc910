# -------------------------------------------------------------------------
# Module:  simple_system
# File:    simple_system.v
# Author:  shawn Liu
# E-mail:  shawn110285@gmail.com
# --------------------------------------------------------------------------

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

.PHONY: all
.DELETE_ON_ERROR:


CURR_ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OPENC910_ROOT_DIR := $(CURR_ROOT_DIR)/../../openc910

CODE_BASE_PATH := $(OPENC910_ROOT_DIR)/C910_RTL_FACTORY

CPU_TILE_FILES := \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/cpu_cfig.h                    \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/sysmap.h                      \
	${CODE_BASE_PATH}/gen_rtl/common/rtl/booth_code.v               \
	${CODE_BASE_PATH}/gen_rtl/common/rtl/booth_code_v1.v            \
	${CODE_BASE_PATH}/gen_rtl/common/rtl/compressor_32.v            \
	${CODE_BASE_PATH}/gen_rtl/common/rtl/compressor_42.v            \
	${CODE_BASE_PATH}/gen_rtl/common/rtl/BUFGCE.v                   \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/csky_apb_1tox_matrix.v       \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_csr_req_arbiter.v      \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_lowpower.v             \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_other_io_sync.v        \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_read_channel.v         \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_req_arbiter.v          \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_snoop_channel.v        \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_top.v                  \
	${CODE_BASE_PATH}/gen_rtl/biu/rtl/ct_biu_write_channel.v        \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_apbif.v                \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_bmbif.v                \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_bmbif_kid.v            \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_ctcq.v                 \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_ctcq_reqq_entry.v      \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_ctcq_respq_entry.v     \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_ebiuif.v               \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_l2cif.v                \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_ncq.v                  \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_ncq_gm.v               \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_regs.v                 \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_regs_kid.v             \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_snb.v                  \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_snb_arb.v              \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_snb_dp_sel.v           \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_snb_dp_sel_16.v        \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_snb_dp_sel_8.v         \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_snb_sab.v              \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_snb_sab_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_top.v                  \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_vb.v                   \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ciu_vb_aw_entry.v          \
	${CODE_BASE_PATH}/gen_rtl/clint/rtl/ct_clint_func.v             \
	${CODE_BASE_PATH}/gen_rtl/clint/rtl/ct_clint_top.v              \
	${CODE_BASE_PATH}/gen_rtl/clk/rtl/ct_clk_top.v                  \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/ct_core.v                     \
	${CODE_BASE_PATH}/gen_rtl/cp0/rtl/ct_cp0_iui.v                  \
	${CODE_BASE_PATH}/gen_rtl/cp0/rtl/ct_cp0_lpmd.v                 \
	${CODE_BASE_PATH}/gen_rtl/cp0/rtl/ct_cp0_regs.v                 \
	${CODE_BASE_PATH}/gen_rtl/cp0/rtl/ct_cp0_top.v                  \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ebiu_cawt_entry.v          \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ebiu_lowpower.v            \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ebiu_ncwt_entry.v          \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ebiu_read_channel.v        \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ebiu_snoop_channel_dummy.v \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ebiu_top.v                 \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_ebiu_write_channel.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_1024x128.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_1024x144.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_1024x32.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_1024x59.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_1024x64.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_1024x92.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_128x104.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_128x144.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_128x16.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_16384x128.v      \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_2048x128.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_2048x144.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_2048x32.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_2048x59.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_2048x88.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x100.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x144.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x196.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x23.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x52.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x54.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x59.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x7.v          \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_256x84.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_32768x128.v      \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_4096x128.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_4096x144.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_4096x32.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_4096x84.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x144.v        \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x22.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x44.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x52.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x54.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x59.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x7.v          \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_512x96.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_64x108.v         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_65536x128.v      \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_8192x128.v       \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/ct_f_spsram_8192x32.v        \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_close_s0_d.v        \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_close_s0_h.v        \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_close_s1_d.v        \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_close_s1_h.v        \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_ctrl.v              \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_double_dp.v         \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_half_dp.v           \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_onehot_sel_d.v      \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_onehot_sel_h.v      \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_scalar_dp.v         \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fadd_top.v               \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_ctrl.v             \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_double_dp.v        \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_dtoh_sh.v          \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_dtos_sh.v          \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_ftoi_sh.v          \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_htos_sh.v          \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_itof_sh.v          \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_scalar_dp.v        \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_stod_sh.v          \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_stoh_sh.v          \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fcnvt_top.v              \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_fifo.v                     \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fspu_ctrl.v              \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fspu_double.v            \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fspu_dp.v                \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fspu_half.v              \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fspu_single.v            \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_fspu_top.v               \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_bkpt.v                 \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_common_dbg_info.v      \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_common_regs.v          \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_common_top.v           \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_ctrl.v                 \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_dbg_info.v             \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_ddc_ctrl.v             \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_ddc_dp.v               \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_etm.v                  \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_etm_if.v               \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_event.v                \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_io.v                   \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_ir.v                   \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_nirv_bkpt.v            \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_pcfifo.v               \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_private_ir.v           \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_private_top.v          \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_regs.v                 \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_serial.v               \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_sm.v                   \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_sync_3flop.v           \
	${CODE_BASE_PATH}/gen_rtl/had/rtl/ct_had_trace.v                \
	${CODE_BASE_PATH}/gen_rtl/pmu/rtl/ct_hpcp_adder_sel.v           \
	${CODE_BASE_PATH}/gen_rtl/pmu/rtl/ct_hpcp_cnt.v                 \
	${CODE_BASE_PATH}/gen_rtl/pmu/rtl/ct_hpcp_cntinten_reg.v        \
	${CODE_BASE_PATH}/gen_rtl/pmu/rtl/ct_hpcp_cntof_reg.v           \
	${CODE_BASE_PATH}/gen_rtl/pmu/rtl/ct_hpcp_event.v               \
	${CODE_BASE_PATH}/gen_rtl/pmu/rtl/ct_hpcp_top.v                 \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_dep_reg_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_dep_reg_src2_entry.v   \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_dep_vreg_entry.v       \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_dep_vreg_srcv2_entry.v \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_id_ctrl.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_id_decd.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_id_decd_special.v      \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_id_dp.v                \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_id_fence.v             \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_id_split_long.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_id_split_short.v       \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_ir_ctrl.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_ir_decd.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_ir_dp.v                \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_ir_frt.v               \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_ir_rt.v                \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_ir_vrt.v               \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_aiq0.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_aiq0_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_aiq1.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_aiq1_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_aiq_lch_rdy_1.v     \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_aiq_lch_rdy_2.v     \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_aiq_lch_rdy_3.v     \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_biq.v               \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_biq_entry.v         \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_ctrl.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_dp.v                \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_lsiq.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_lsiq_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_pipe_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_sdiq.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_sdiq_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_viq0.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_viq0_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_viq1.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_is_viq1_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_ctrl.v              \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_dp.v                \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_fwd.v               \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_fwd_preg.v          \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_fwd_vreg.v          \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_pipe0_decd.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_pipe1_decd.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_pipe2_decd.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_pipe3_decd.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_pipe4_decd.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_pipe6_decd.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_pipe7_decd.v        \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_prf_eregfile.v      \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_prf_fregfile.v      \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_prf_gated_ereg.v    \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_prf_gated_preg.v    \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_prf_gated_vreg.v    \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_prf_pregfile.v      \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_rf_prf_vregfile.v      \
	${CODE_BASE_PATH}/gen_rtl/idu/rtl/ct_idu_top.v                  \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_addrgen.v              \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_bht.v                  \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_bht_pre_array.v        \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_bht_sel_array.v        \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_btb.v                  \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_btb_data_array.v       \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_btb_tag_array.v        \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_debug.v                \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_decd_normal.v          \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ibctrl.v               \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ibdp.v                 \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ibuf.v                 \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ibuf_entry.v           \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_icache_data_array0.v   \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_icache_data_array1.v   \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_icache_if.v            \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_icache_predecd_array0.v    \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_icache_predecd_array1.v    \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_icache_tag_array.v         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ifctrl.v                   \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ifdp.v                     \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ind_btb.v                  \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ind_btb_array.v            \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ipb.v                      \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ipctrl.v                   \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ipdecode.v                 \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ipdp.v                     \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_l0_btb.v                   \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_l0_btb_entry.v             \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_l1_refill.v                \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_lbuf.v                     \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_lbuf_entry.v               \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_pcfifo_if.v                \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_pcgen.v                    \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_precode.v                  \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_ras.v                      \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_sfp.v                      \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_sfp_entry.v                \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_ifu_vector.v                   \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_alu.v                        \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_bju.v                        \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_bju_pcfifo.v                 \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_bju_pcfifo_entry.v           \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_bju_pcfifo_read_entry.v      \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_cbus.v                       \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_div.v                        \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_div_entry.v                  \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_div_srt_radix16.v            \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_mult.v                       \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_rbus.v                       \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_special.v                    \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/ct_iu_top.v                        \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_cmp.v                      \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_data.v                     \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_icc.v                      \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_prefetch.v                 \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_sub_bank.v                 \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_tag.v                      \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_tag_ecc.v                  \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2c_wb.v                       \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2cache_data_array.v           \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2cache_dirty_array_16way.v    \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2cache_tag_array_16way.v      \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_l2cache_top.v                  \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_amr.v                      \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_bus_arb.v                  \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_cache_buffer.v             \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_ctrl.v                     \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_dcache_arb.v               \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_dcache_data_array.v        \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_dcache_dirty_array.v       \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_dcache_info_update.v       \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_dcache_ld_tag_array.v      \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_dcache_tag_array.v         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_dcache_top.v               \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_icc.v                      \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_idfifo_8.v                 \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_idfifo_entry.v             \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_ld_ag.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_ld_da.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_ld_dc.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_ld_wb.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_lfb.v                      \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_lfb_addr_entry.v           \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_lfb_data_entry.v           \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_lm.v                       \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_lq.v                       \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_lq_entry.v                 \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_mcic.v                     \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu.v                      \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_gpfb.v                 \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_gsdb.v                 \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_pfb_entry.v            \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_pfb_l1sm.v             \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_pfb_l2sm.v             \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_pfb_tsm.v              \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_pmb_entry.v            \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_sdb_cmp.v              \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_pfu_sdb_entry.v            \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_rb.v                       \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_rb_entry.v                 \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_rot_data.v                 \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_sd_ex1.v                   \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_snoop_ctcq.v               \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_snoop_ctcq_entry.v         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_snoop_req_arbiter.v        \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_snoop_resp.v               \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_snoop_snq.v                \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_snoop_snq_entry.v          \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_spec_fail_predict.v        \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_sq.v                       \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_sq_entry.v                 \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_st_ag.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_st_da.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_st_dc.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_st_wb.v                    \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_vb.v                       \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_vb_addr_entry.v            \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_vb_sdb_data.v              \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_vb_sdb_data_entry.v        \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_wmb.v                      \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_wmb_ce.v                   \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_lsu_wmb_entry.v                \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_arb.v                      \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_dplru.v                    \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_dutlb.v                    \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_dutlb_entry.v              \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_dutlb_huge_entry.v         \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_dutlb_read.v               \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_iplru.v                    \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_iutlb.v                    \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_iutlb_entry.v              \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_iutlb_fst_entry.v          \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_jtlb.v                     \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_jtlb_data_array.v          \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_jtlb_tag_array.v           \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_ptw.v                      \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_regs.v                     \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_sysmap.v                   \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_sysmap_hit.v               \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_tlboper.v                  \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_mmu_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/clk/rtl/ct_mp_clk_top.v                   \
	${CODE_BASE_PATH}/gen_rtl/rst/rtl/ct_mp_rst_top.v                   \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/openC910.v                        \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_piu_other_io.v                 \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_piu_other_io_dummy.v           \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_piu_other_io_sync.v            \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_piu_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_piu_top_dummy.v                \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_piu_top_dummy_device.v         \
	${CODE_BASE_PATH}/gen_rtl/pmp/rtl/ct_pmp_acc.v                      \
	${CODE_BASE_PATH}/gen_rtl/pmp/rtl/ct_pmp_comp_hit.v                 \
	${CODE_BASE_PATH}/gen_rtl/pmp/rtl/ct_pmp_regs.v                     \
	${CODE_BASE_PATH}/gen_rtl/pmp/rtl/ct_pmp_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/ciu/rtl/ct_prio.v                         \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/ct_rmu_top_dummy.v                \
	${CODE_BASE_PATH}/gen_rtl/rst/rtl/ct_rst_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_compare_iid.v              \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_encode_32.v                \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_encode_64.v                \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_encode_8.v                 \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_encode_96.v                \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_expand_32.v                \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_expand_64.v                \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_expand_8.v                 \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_expand_96.v                \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_pst_ereg.v                 \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_pst_ereg_entry.v           \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_pst_preg.v                 \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_pst_preg_entry.v           \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_pst_vreg.v                 \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_pst_vreg_dummy.v           \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_pst_vreg_entry.v           \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_retire.v                   \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_rob.v                      \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_rob_entry.v                \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_rob_expt.v                 \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_rob_rt.v                   \
	${CODE_BASE_PATH}/gen_rtl/rtu/rtl/ct_rtu_top.v                      \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_1024x128.v              \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_1024x144.v              \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_1024x32.v               \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_1024x59.v               \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_1024x64.v               \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_1024x92.v               \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_128x104.v               \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_128x144.v               \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_128x16.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_16384x128.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_2048x128.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_2048x144.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_2048x32.v                         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_2048x32_split.v                         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_2048x59.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_2048x88.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_256x100.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_256x144.v                         \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_spsram_256x196.v                         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_256x23.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_256x52.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_256x54.v                         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_256x59.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_256x7.v                         \
	${CODE_BASE_PATH}/gen_rtl/mmu/rtl/ct_spsram_256x84.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_32768x128.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_4096x128.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_4096x144.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_4096x32.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_4096x84.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_512x144.v                         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_512x22.v                         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_512x44.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_512x52.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_512x54.v                         \
	${CODE_BASE_PATH}/gen_rtl/ifu/rtl/ct_spsram_512x59.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_512x7.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_512x96.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_64x108.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_65536x128.v                         \
	${CODE_BASE_PATH}/gen_rtl/l2c/rtl/ct_spsram_8192x128.v                         \
	${CODE_BASE_PATH}/gen_rtl/lsu/rtl/ct_spsram_8192x32.v                         \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/ct_sysio_kid.v                         \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/ct_sysio_top.v                         \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/ct_top.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_vfalu_dp_pipe6.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_vfalu_dp_pipe7.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_vfalu_top_pipe6.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfalu/rtl/ct_vfalu_top_pipe7.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_ctrl.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_double.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_ff1.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_pack.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_prepare.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_round.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_scalar_dp.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_srt.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_srt_radix16_bound_table.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_srt_radix16_only_div.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_srt_radix16_with_sqrt.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfdsu/rtl/ct_vfdsu_top.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_ctrl.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_dp.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_ff1_10bit.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_lza.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_lza_32.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_lza_42.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_lza_simd_half.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_mult1.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_mult_compressor.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_mult_simd_half.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfmau/rtl/ct_vfmau_top.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfpu/rtl/ct_vfpu_cbus.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfpu/rtl/ct_vfpu_ctrl.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfpu/rtl/ct_vfpu_dp.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfpu/rtl/ct_vfpu_rbus.v                         \
	${CODE_BASE_PATH}/gen_rtl/vfpu/rtl/ct_vfpu_top.v                         \
	${CODE_BASE_PATH}/gen_rtl/fpga/rtl/fpga_ram.v                         \
	${CODE_BASE_PATH}/gen_rtl/clk/rtl/gated_clk_cell.v                         \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/mp_top_golden_port.v                         \
	${CODE_BASE_PATH}/gen_rtl/iu/rtl/multiplier_65x65_3_stage.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_32to1_arb.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_arb_ctrl.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_ctrl.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_granu2_arb.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_granu_arb.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_hart_arb.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_hreg_busif.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_int_kid.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_kid_busif.v                         \
	${CODE_BASE_PATH}/gen_rtl/plic/rtl/plic_top.v                         \
	${CODE_BASE_PATH}/gen_rtl/common/rtl/sync_level2level.v                         \
	${CODE_BASE_PATH}/gen_rtl/common/rtl/sync_level2pulse.v                         \
	${CODE_BASE_PATH}/gen_rtl/cpu/rtl/top_golden_port.v

#===============================SOC Testbench Files ========================================
SMART_RUN_DIR := $(OPENC910_ROOT_DIR)/smart_run
LOGICAL_BASE_PATH := $(SMART_RUN_DIR)/logical

SOC_FILES := \
	$(LOGICAL_BASE_PATH)/ahb/ahb2apb.v                           \
    $(LOGICAL_BASE_PATH)/ahb/ahb.v                               \
	$(LOGICAL_BASE_PATH)/apb/apb_bridge.v                        \
    $(LOGICAL_BASE_PATH)/apb/apb.v                               \
	$(LOGICAL_BASE_PATH)/axi/axi2ahb.v                           \
	$(LOGICAL_BASE_PATH)/axi/axi_err128.v                        \
	$(LOGICAL_BASE_PATH)/axi/axi_fifo_entry.v                    \
	$(LOGICAL_BASE_PATH)/axi/axi_fifo.v                          \
	$(LOGICAL_BASE_PATH)/axi/axi_interconnect128.v               \
	$(LOGICAL_BASE_PATH)/axi/axi_slave128.v                      \
	$(LOGICAL_BASE_PATH)/common/clk_gen.v                        \
	$(LOGICAL_BASE_PATH)/common/cpu_sub_system_axi.v             \
	$(LOGICAL_BASE_PATH)/common/err_gen.v                        \
	$(LOGICAL_BASE_PATH)/common/fifo_counter.v                   \
	$(LOGICAL_BASE_PATH)/common/fpga_clk_gen.v                   \
	$(LOGICAL_BASE_PATH)/common/rv_integration_platform.v        \
	$(LOGICAL_BASE_PATH)/common/soc.v                            \
	$(LOGICAL_BASE_PATH)/common/timer.v                          \
	$(LOGICAL_BASE_PATH)/common/wid_entry.v                      \
	$(LOGICAL_BASE_PATH)/common/wid_for_axi4.v                   \
	$(LOGICAL_BASE_PATH)/gpio/gpio_apbif.v                       \
	$(LOGICAL_BASE_PATH)/gpio/gpio_ctrl.v                        \
	$(LOGICAL_BASE_PATH)/gpio/gpio.v                             \
	$(LOGICAL_BASE_PATH)/mem/f_spsram_32768x128.v                \
	$(LOGICAL_BASE_PATH)/mem/f_spsram_large.v                    \
	$(LOGICAL_BASE_PATH)/mem/mem_ctrl.v                          \
	$(LOGICAL_BASE_PATH)/mem/ram.v                               \
	$(LOGICAL_BASE_PATH)/pmu/pmu.v                               \
	$(LOGICAL_BASE_PATH)/pmu/px_had_sync.v                       \
	$(LOGICAL_BASE_PATH)/pmu/sync.v                              \
	$(LOGICAL_BASE_PATH)/pmu/tap2_sm.v                           \
	$(LOGICAL_BASE_PATH)/uart/uart_apb_reg.v                     \
	$(LOGICAL_BASE_PATH)/uart/uart_baud_gen.v                    \
	$(LOGICAL_BASE_PATH)/uart/uart_ctrl.v                        \
	$(LOGICAL_BASE_PATH)/uart/uart_receive.v                     \
	$(LOGICAL_BASE_PATH)/uart/uart_trans.v                       \
	$(LOGICAL_BASE_PATH)/uart/uart.v                             \
	$(LOGICAL_BASE_PATH)/tb/tb_verilator.v                       \
	$(LOGICAL_BASE_PATH)/tb/int_mnt.v
#	$(LOGICAL_BASE_PATH)/tb/tb.v
#   $(LOGICAL_BASE_PATH)/common/BUFGCE.v

# for verilator_tb, it should change to top, otherwise it should be soc
TOP_MOD := top

VERILOG_FILES := $(CPU_TILE_FILES) \
	$(SOC_FILES)


VERILOG_OBJ_DIR := ./obj_dir
VERILATOR = verilator

#-Wall                      Enable all style warnings
#-Wno-style                 Disable all style warnings
#-Werror-<message>          Convert warnings to errors
#-Wno-lint                  Disable all lint warnings
#-Wno-<message>             Disable warning
#-I<dir>                    Directory to search for includes
#-D<macro>

# VFLAGS := --cc -trace -Wall
VFLAGS := --cc -trace -Wno-style -Wno-lint -Wno-IMPLICIT -Wno-WIDTH -Wno-CASEINCOMPLETE -Wno-WIDTHCONCAT -Wno-UNOPTFLAT -Wno-UNSIGNED  -Wno-MULTIDRIVEN -Wno-COMBDLY #-I$(TB_DIR)

INC_DIR :=${CODE_BASE_PATH}/gen_rtl/cpu/rtl

## Find the directory containing the Verilog sources.  This is given from
## calling: "verilator -V" and finding the VERILATOR_ROOT output line from
## within it.  From this VERILATOR_ROOT value, we can find all the components
## we need here--in particular, the verilator include directory
VERILATOR_ROOT ?= $(shell bash -c '$(VERILATOR) -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')

## The directory containing the verilator includes
VINC = $(VERILATOR_ROOT)/include
VINC1 = $(VERILATOR_ROOT)/include/vltstd

$(VERILOG_OBJ_DIR):
	mkdir $@

# covert the verilog file into the cpp file
$(VERILOG_OBJ_DIR)/V$(TOP_MOD).cpp: $(VERILOG_FILES)
	@echo "===================compile RTL into cpp files, start=========================="
	$(VERILATOR) $(VFLAGS) -I$(INC_DIR) --top-module $(TOP_MOD) $(VERILOG_FILES) V$(TOP_MOD).cpp
	@echo "===================compile RTL into cpp files, end ==========================="

# create the c++ lib from the above cpp file
$(VERILOG_OBJ_DIR)/V$(TOP_MOD)__ALL.a: $(VERILOG_OBJ_DIR)/V$(TOP_MOD).cpp
	@echo "===============add rtl object files into cpp files, start======================"
#	make --no-print-directory -C $(VERILOG_OBJ_DIR) -f V$(TOP_MOD).mk
	make -C $(VERILOG_OBJ_DIR) -f V$(TOP_MOD).mk
	@echo "===============add rtl object files into cpp files, end======================"

all: $(VERILOG_OBJ_DIR)/V$(TOP_MOD)__ALL.a $(VERILOG_OBJ_DIR)

.PHONY: clean
clean:
	@echo "=========================cleaning RTL objects, start============================"
	rm -rf ./$(VERILOG_OBJ_DIR)/
	@echo "=========================cleaning RTL objects, end============================"

